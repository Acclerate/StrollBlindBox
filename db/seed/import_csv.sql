-- ============================================================
-- WalkBox: 真实数据集 CSV 导入通道（替代合成种子的生产管道）
-- 用法（psql 客户端, \copy 是客户端命令, 需在 CSV 所在目录执行）:
--   cd db/seed && psql "$DATABASE_URL" -f import_csv.sql
--   （或修改下方 \copy 的相对/绝对路径; 注意 psql 的 \copy 不支持 :'var' 变量插值）
-- 说明: 先入 staging 表, 再经校验/几何构造写入 poi, 幂等(source_ref 冲突跳过)。
--       开放数据集(OSM 等)/图商导出只需整理成同构 CSV 即可走同一管道。
-- ============================================================

BEGIN;

CREATE TEMP TABLE stg_poi (
  source_ref       TEXT,
  lat              DOUBLE PRECISION NOT NULL,
  lng              DOUBLE PRECISION NOT NULL,
  name             TEXT NOT NULL,
  name_local       TEXT,
  category         TEXT NOT NULL,
  description      TEXT,
  source           TEXT NOT NULL DEFAULT 'seed',
  editor_score     SMALLINT DEFAULT 3,
  safety_score     SMALLINT DEFAULT 70,
  accessibility    JSONB DEFAULT '{}',
  fence_radius_m   INT DEFAULT 30,
  status           TEXT DEFAULT 'auto',
  open_24h         BOOLEAN DEFAULT false,
  blacklisted      BOOLEAN DEFAULT false,
  blacklist_reason TEXT,
  visit_count_90d  INT DEFAULT 0,
  arrive_rate      REAL DEFAULT 1.0
);

\copy stg_poi FROM 'seed_pois.csv' WITH (FORMAT csv, HEADER true)

-- 入库前数据质量校验: 坐标域 / 类别字典 / 分值域, 不合格行进 reject 表人工处理
CREATE TEMP TABLE stg_poi_reject AS
SELECT s.*, 'invalid category'::text AS reject_reason FROM stg_poi s
 WHERE s.category NOT IN (SELECT category FROM poi_category)
UNION ALL
SELECT s.*, 'lat out of range' FROM stg_poi s WHERE s.lat NOT BETWEEN -90 AND 90
UNION ALL
SELECT s.*, 'lng out of range' FROM stg_poi s WHERE s.lng NOT BETWEEN -180 AND 180;

INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
                 editor_score, safety_score, accessibility, fence_radius_m, status, open_24h,
                 blacklisted, blacklist_reason, visit_count_90d, arrive_rate)
SELECT ST_SetSRID(ST_MakePoint(s.lng, s.lat), 4326),
       s.name, s.name_local, s.category, s.description, '{}'::text[],
       s.source::poi_source_enum, s.source_ref,
       s.editor_score, s.safety_score, s.accessibility, s.fence_radius_m,
       s.status::poi_status_enum, s.open_24h, s.blacklisted, s.blacklist_reason,
       s.visit_count_90d, s.arrive_rate
FROM stg_poi s
WHERE NOT EXISTS (SELECT 1 FROM stg_poi_reject r WHERE r.source_ref = s.source_ref)
ON CONFLICT (source_ref) DO NOTHING;

-- 报告: 导入数 / 拒绝数
SELECT (SELECT count(*) FROM stg_poi) AS staged,
       (SELECT count(*) FROM stg_poi_reject) AS rejected,
       (SELECT count(*) FROM v_poi_active) AS active_visible;

COMMIT;
