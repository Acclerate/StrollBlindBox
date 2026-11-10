-- ============================================================
-- WalkBox 001: 扩展
-- 依赖: PostgreSQL 16 + PostGIS 3.4
-- 幂等: 可重复执行
-- ============================================================

CREATE EXTENSION IF NOT EXISTS postgis;    -- 地理检索 / 围栏
CREATE EXTENSION IF NOT EXISTS pgcrypto;   -- gen_random_uuid() (PG16 已内建，显式启用以兼容旧版)
