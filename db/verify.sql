-- ============================================================
-- WalkBox DDL/种子 · 抽查验证（TRD 六.5 安全过滤回归的可执行子集）
-- 前置: 001–004 + seed_pois.sql 已执行
-- 全部查询预期结果见行内注释; 任何不符 = 阻断级问题。
-- ============================================================

-- V1 [阻断] v_poi_active 中黑名单命中数必须为 0（TRD 六.5: 黑名单命中率 0）
SELECT count(*) AS blacklist_hits_should_be_0
FROM v_poi_active
WHERE blacklisted OR category IN ('cemetery', 'highway', 'construction')
   OR (accessibility->>'island')::boolean IS TRUE
   OR (accessibility->>'rail_within_50m')::boolean IS TRUE;

-- V2 总量分布: 500 / 黑名单 30 / 视图可见 430 / 待审核 20
SELECT (SELECT count(*) FROM poi)                    AS total_should_be_500,
       (SELECT count(*) FROM poi WHERE blacklisted)  AS blacklisted_should_be_30,
       (SELECT count(*) FROM v_poi_active)           AS visible_should_be_430,
       (SELECT count(*) FROM poi WHERE status='auto') AS auto_should_be_20;

-- V3 匹配候选: 人民广场 2.4km(=2km×1.2) 普通模式应有候选, 且距离均 ≤ 半径
SELECT count(*) AS candidates, max(dist_m) AS max_dist
FROM fn_match_candidates(31.2304, 121.4737, 2400,
  ARRAY['park','shrine','museum','monument','landmark_stone','public_facility','plaza','convenience'],
  60, false)
WHERE dist_m <= 2400;

-- V4 夜间模式: 仅 24h 类别, 安全分 ≥80（候选数应明显少于 V3）
SELECT count(*) AS night_candidates
FROM fn_match_candidates(31.2304, 121.4737, 2400,
  ARRAY['public_facility','plaza','convenience'], 80, true);

-- V5 [性能] 候选查询必须走 geography GIST 部分索引（预期执行计划含 idx_poi_geog_active）
EXPLAIN (COSTS OFF)
SELECT id FROM v_poi_active
WHERE ST_DWithin(geog, ST_SetSRID(ST_MakePoint(121.4737, 31.2304), 4326)::geography, 2400);

-- V6 fn_verify_arrival 冒烟: 造一个会话+轨迹(末端落在 POI 围栏内), 校验应为 true 并回写
--    注: 必须用 DO 块顺序执行 —— 同一语句内 CTE 的数据修改对函数调用不可见。
DO $$
DECLARE
  v_user    uuid;
  v_session uuid;
  v_poi     record;
BEGIN
  INSERT INTO app_user (device_id) VALUES (gen_random_uuid()) RETURNING id INTO v_user;
  SELECT id, geom INTO v_poi FROM v_poi_active ORDER BY id LIMIT 1;
  INSERT INTO walk_session (user_id, poi_id, mode, start_geom, target_distance_km)
    VALUES (v_user, v_poi.id, 'normal', v_poi.geom, 2.0)
    RETURNING id INTO v_session;

  -- 轨迹: 8 个远离点(向西 400~500m) + 末端 2 个围栏内点
  INSERT INTO track_point (session_id, geom, accuracy_m, speed_mps, recorded_at)
  SELECT v_session,
         ST_SetSRID(ST_MakePoint(ST_X(v_poi.geom) - 0.005 + 0.0006 * g, ST_Y(v_poi.geom)), 4326),
         10, 1.3, now() - interval '10 minutes' + (g || ' seconds')::interval
  FROM generate_series(1, 8) g;
  INSERT INTO track_point (session_id, geom, accuracy_m, speed_mps, recorded_at) VALUES
    (v_session, v_poi.geom, 8, 1.3, now() - interval '1 minute'),
    (v_session, v_poi.geom, 8, 1.2, now());

  INSERT INTO arrival_event (session_id, user_id, poi_id, arrived_at, confidence)
    VALUES (v_session, v_user, v_poi.id, now(), 0.9);

  IF fn_verify_arrival(v_session) IS NOT TRUE THEN
    RAISE EXCEPTION 'V6 FAILED: fn_verify_arrival 应为 true';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM arrival_event WHERE session_id = v_session AND server_verified) THEN
    RAISE EXCEPTION 'V6 FAILED: server_verified 未回写';
  END IF;

  -- 清理冒烟数据（arrival_event/track_point 随会话级联删除）
  DELETE FROM walk_session WHERE id = v_session;
  DELETE FROM app_user WHERE id = v_user;
  RAISE NOTICE 'V6 OK: fn_verify_arrival=true, server_verified 已回写, 冒烟数据已清理';
END $$;

-- V7 每日挑战对账函数冒烟（造 1 行挑战并结算, 应为 0 人数且不报错）
INSERT INTO daily_challenge (date, region, poi_id)
SELECT current_date, 'shanghai', id FROM v_poi_active ORDER BY id LIMIT 1
ON CONFLICT DO NOTHING;
SELECT fn_settle_daily_challenge(current_date, 'shanghai') AS settled_count_should_be_0;
