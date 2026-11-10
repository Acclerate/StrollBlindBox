-- ============================================================
-- WalkBox 003: 索引（每条附用途注释）
-- 幂等: 使用 IF NOT EXISTS
-- ============================================================

-- POI 地理检索主索引: 匹配服务 ST_DWithin 候选查询。
-- 注意: 米制候选查询走 geography（生成列 geog）, geometry GIST 服务度/度域查询。
-- 部分索引仅覆盖 active，黑名单/banned POI 不进索引（过滤入口在 v_poi_active 视图）。
CREATE INDEX IF NOT EXISTS idx_poi_geog_active ON poi USING GIST (geog) WHERE status = 'active';
COMMENT ON INDEX idx_poi_geog_active IS '匹配候选 ST_DWithin(geography) 范围查询, 仅 active';

CREATE INDEX IF NOT EXISTS idx_poi_geom ON poi USING GIST (geom);
COMMENT ON INDEX idx_poi_geom IS 'geometry 通用 GIST(管理后台按行政区/框选等)';

-- 审核后台按状态/类别筛队列
CREATE INDEX IF NOT EXISTS idx_poi_status_category ON poi (status, category);

-- arrive_rate < 0.6 自动下线巡检（TRD 2.4 质量清理）
CREATE INDEX IF NOT EXISTS idx_poi_arrive_rate ON poi (arrive_rate) WHERE status = 'active';

-- 会话按用户+状态查活跃/历史（TRD 三. walk_session(user_id,status)）
CREATE INDEX IF NOT EXISTS idx_walk_session_user_status ON walk_session (user_id, status);
CREATE INDEX IF NOT EXISTS idx_walk_session_poi ON walk_session (poi_id);

-- 抵达事件: 图鉴聚合 / POI 热度统计（TRD 三. arrival_event(poi_id, arrived_at)）
CREATE INDEX IF NOT EXISTS idx_arrival_event_poi_time ON arrival_event (poi_id, arrived_at DESC);
CREATE INDEX IF NOT EXISTS idx_arrival_event_user_time ON arrival_event (user_id, arrived_at DESC);

-- 轨迹: 会话回放(服务端二次校验取末端轨迹)
CREATE INDEX IF NOT EXISTS idx_track_point_session_time ON track_point (session_id, recorded_at);
-- 轨迹: 90 天滚动删除的顺序扫描
CREATE INDEX IF NOT EXISTS idx_track_point_retention ON track_point (recorded_at);

-- 每日挑战反查
CREATE INDEX IF NOT EXISTS idx_daily_challenge_poi ON daily_challenge (poi_id);
