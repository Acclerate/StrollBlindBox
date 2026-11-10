-- ============================================================
-- WalkBox 004: 视图 / 函数 / 触发器
-- 幂等: CREATE OR REPLACE
-- ============================================================

-- ---------- updated_at 触发器 ----------
CREATE OR REPLACE FUNCTION fn_touch_updated_at() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_poi_touch ON poi;
CREATE TRIGGER trg_poi_touch BEFORE UPDATE ON poi
  FOR EACH ROW EXECUTE FUNCTION fn_touch_updated_at();

DROP TRIGGER IF EXISTS trg_walk_session_touch ON walk_session;
CREATE TRIGGER trg_walk_session_touch BEFORE UPDATE ON walk_session
  FOR EACH ROW EXECUTE FUNCTION fn_touch_updated_at();

-- ---------- 安全视图: 匹配服务对 POI 的唯一可见入口（TRD 2.6 阻断级） ----------
-- 规则: status=active AND 未命中黑名单 AND 抵达率不低于清理线。
-- 任何安全规则命中(blacklisted=true)在此即不可见，端上缓存规则版本仅作离线兜底。
CREATE OR REPLACE VIEW v_poi_active AS
SELECT p.*
FROM poi p
WHERE p.status = 'active'
  AND NOT p.blacklisted
  AND p.arrive_rate >= 0.6;

-- ---------- 用户 30 天去重集（TRD 2.1 硬过滤第 1 条） ----------
CREATE OR REPLACE VIEW v_user_visited_30d AS
SELECT DISTINCT ae.user_id, ae.poi_id
FROM arrival_event ae
WHERE ae.server_verified
  AND ae.arrived_at > now() - interval '30 days';

-- ---------- 匹配候选查询（与原型 matcher.ts 候选阶段语义一致） ----------
-- 入参: 用户坐标/半径(米, 建议传 D*1.2)/类别白名单/最低安全分/夜间开关
-- 出参: 候选 POI + 直线距离 dist_m（绕转系数修正与加权随机在应用层完成）
CREATE OR REPLACE FUNCTION fn_match_candidates(
  p_lat         double precision,
  p_lng         double precision,
  p_radius_m    double precision,
  p_categories  text[] DEFAULT NULL,
  p_min_safety  int DEFAULT 60,
  p_night       boolean DEFAULT false
)
RETURNS TABLE (
  id bigint, name text, category text, geom geometry,
  dist_m double precision, fence_radius_m int,
  editor_score smallint, safety_score smallint,
  visit_count_90d int, arrive_rate real,
  open_24h boolean, accessibility jsonb
)
LANGUAGE sql STABLE PARALLEL SAFE AS $$
  SELECT p.id, p.name, p.category, p.geom,
         ST_Distance(p.geog, ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography) AS dist_m,
         p.fence_radius_m,
         p.editor_score, p.safety_score,
         p.visit_count_90d, p.arrive_rate,
         p.open_24h, p.accessibility
  FROM v_poi_active p
  WHERE ST_DWithin(p.geog, ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography, p_radius_m)
    AND (p_categories IS NULL OR p.category = ANY (p_categories))
    AND p.safety_score >= p_min_safety
    AND (NOT p_night OR p.open_24h)          -- 夜间模式: 仅 24h/照明良好类别
$$;

-- ---------- 服务端抵达二次校验（TRD 2.3） ----------
-- 规则: 会话存在且 POI 已定; 轨迹末端(最后 10 点)中至少 1 点落在围栏内,
--       且末端最近点距离 <= fence_radius_m → 校验通过并回写 server_verified。
-- 返回: true=通过; false=不通过(轨迹缺失/距离不符); NULL=会话不存在
CREATE OR REPLACE FUNCTION fn_verify_arrival(p_session_id uuid)
RETURNS boolean AS $$
DECLARE
  v_fence     int;
  v_poi_geom  geometry;
  v_min_dist  double precision;
  v_n_points  bigint;
BEGIN
  -- 会话与其目的地
  SELECT p.fence_radius_m, p.geom
    INTO v_fence, v_poi_geom
  FROM walk_session ws
  JOIN poi p ON p.id = ws.poi_id
  WHERE ws.id = p_session_id;
  IF NOT FOUND THEN RETURN NULL; END IF;                 -- 会话不存在

  -- 轨迹末端 10 点中, 距 POI 的最小地表距离
  SELECT min(ST_Distance(tp.geom::geography, v_poi_geom::geography)), count(*)
    INTO v_min_dist, v_n_points
  FROM (
    SELECT geom FROM track_point
    WHERE session_id = p_session_id
    ORDER BY recorded_at DESC
    LIMIT 10
  ) tp;  -- 轨迹表小(末端10点), 顺序扫描即可; 大规模时再为 track_point 增加 geog 生成列
  IF v_n_points IS NULL OR v_n_points = 0 THEN
    RETURN false;                                        -- 无补传轨迹, 拒绝
  END IF;

  IF v_min_dist <= v_fence THEN
    UPDATE arrival_event
       SET server_verified = true
     WHERE session_id = p_session_id;
    RETURN true;
  END IF;
  RETURN false;                                          -- 轨迹终点不在围栏内
END $$ LANGUAGE plpgsql;

-- ---------- 每日挑战计数对账（Redis INCR → 每日落库, TRD 2.5） ----------
CREATE OR REPLACE FUNCTION fn_settle_daily_challenge(p_date date, p_region text)
RETURNS int AS $$
DECLARE
  v_count int;
BEGIN
  SELECT count(*) INTO v_count
  FROM arrival_event ae
  JOIN daily_challenge dc
    ON dc.date = p_date AND dc.region = p_region AND dc.poi_id = ae.poi_id
  WHERE ae.server_verified
    AND ae.arrived_at >= p_date
    AND ae.arrived_at <  p_date + interval '1 day';

  UPDATE daily_challenge
     SET arrival_count = v_count
   WHERE date = p_date AND region = p_region;
  RETURN v_count;
END $$ LANGUAGE plpgsql;

-- ---------- 黑名单批量刷新（规则库热更新后调用, TRD 2.6） ----------
-- 把 blacklist_category 规则应用到 POI 表的黑名单标记。几何型黑名单
-- (铁路沿线/水域孤岛)由离线预计算管道写入 accessibility, 此处按标记联动。
CREATE OR REPLACE FUNCTION fn_refresh_blacklist()
RETURNS int AS $$
DECLARE
  v_updated int;
  v_more    int;
BEGIN
  -- 1) 类别级规则
  UPDATE poi p
     SET blacklisted = true,
         blacklist_reason = 'rule:blacklist_category:' || r.category_hit
    FROM (
      SELECT jsonb_array_elements_text(config->'categories') AS category_hit, city_code
      FROM poi_safety_rule
      WHERE rule_type = 'blacklist_category' AND enabled
    ) r
   WHERE p.category = r.category_hit
     AND NOT p.blacklisted;

  GET DIAGNOSTICS v_updated = ROW_COUNT;

  -- 2) accessibility 预计算标记联动 (ferry_gap 孤岛/铁路沿线等由离线管道维护)
  UPDATE poi
     SET blacklisted = true,
         blacklist_reason = coalesce(blacklist_reason, 'accessibility:unreachable')
   WHERE NOT blacklisted
     AND (
       (accessibility->>'island')::boolean IS TRUE
       OR (accessibility->>'rail_within_50m')::boolean IS TRUE
     );

  GET DIAGNOSTICS v_more = ROW_COUNT;
  RETURN v_updated + v_more;
END $$ LANGUAGE plpgsql;
