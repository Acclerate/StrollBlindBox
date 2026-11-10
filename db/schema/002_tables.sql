-- ============================================================
-- WalkBox 002: 表结构（完整 DDL）
-- 对应 TRD 第三章数据模型，扩展为可建库版本。
-- 时间字段一律 TIMESTAMPTZ（UTC 存储，展示按设备时区）。
-- 幂等: 先 DROP 再 CREATE（开发期）；生产请改用迁移工具增量执行。
-- ============================================================

-- ---------- 枚举 ----------
DO $$ BEGIN
  CREATE TYPE poi_source_enum AS ENUM ('seed', 'auto', 'manual');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE poi_status_enum AS ENUM ('auto', 'active', 'banned', 'retired');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE session_mode_enum AS ENUM ('normal', 'overseas', 'night');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE session_status_enum AS ENUM ('walking', 'arrived', 'quit', 'expired');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE auth_provider_enum AS ENUM ('apple', 'wechat', 'google');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ---------- 用户（匿名设备优先，登录仅用于云同步，TRD 四.鉴权） ----------
CREATE TABLE IF NOT EXISTS app_user (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id      UUID NOT NULL UNIQUE,                 -- 首启生成，匿名即可玩核心闭环
  auth_provider  auth_provider_enum,                   -- 可选登录
  auth_uid       TEXT,
  display_name   TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_seen_at   TIMESTAMPTZ,
  CONSTRAINT uq_app_user_auth UNIQUE (auth_provider, auth_uid)  -- NULL 不参与唯一性，匿名可多条
);

-- ---------- POI 类别字典（模式白名单 / 稀有加成 / 绕转系数单一事实来源） ----------
CREATE TABLE IF NOT EXISTS poi_category (
  category       TEXT PRIMARY KEY,
  description    TEXT,
  night_allowed  BOOLEAN NOT NULL DEFAULT false,       -- 夜间模式(22:00–05:00 本地)允许下发
  surprise_boost REAL NOT NULL DEFAULT 1.0 CHECK (surprise_boost >= 1.0),  -- w_serp 稀有类别加成
  detour_class   TEXT NOT NULL DEFAULT 'urban'         -- 路网绕转系数分级 urban/suburb/rural
);

-- ---------- POI 主表 ----------
CREATE TABLE IF NOT EXISTS poi (
  id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  geom             GEOMETRY(Point, 4326) NOT NULL,
  -- 生成列: 米制距离查询(ST_DWithin/ST_Distance)走 geography 索引, 与 geometry 索引互不替代
  geog             GEOGRAPHY(Point, 4326) GENERATED ALWAYS AS (geom::geography) STORED,
  name             TEXT NOT NULL,
  name_local       TEXT,
  category         TEXT NOT NULL REFERENCES poi_category(category) ON UPDATE CASCADE,
  description      TEXT,
  photos           TEXT[] NOT NULL DEFAULT '{}',       -- 对象存储 key 列表
  source           poi_source_enum NOT NULL DEFAULT 'seed',
  source_ref       TEXT UNIQUE,                        -- 来源系统唯一引用: seed:0001 / osm:node123 / gplaces:ChIJ…（幂等导入 & 防重）
  editor_score     SMALLINT NOT NULL DEFAULT 3 CHECK (editor_score BETWEEN 1 AND 5),
  safety_score     SMALLINT NOT NULL DEFAULT 70 CHECK (safety_score BETWEEN 0 AND 100),
  accessibility    JSONB NOT NULL DEFAULT '{}'::jsonb, -- {ferry_gap:bool, gated:bool, near_rail:bool, island:bool}
  fence_radius_m   INT NOT NULL DEFAULT 30 CHECK (fence_radius_m BETWEEN 10 AND 200),  -- 大型公园可至 80
  status           poi_status_enum NOT NULL DEFAULT 'auto',   -- auto 待审核 / active / banned / retired(抵达率下线)
  open_24h         BOOLEAN NOT NULL DEFAULT false,     -- 夜间模式过滤依赖
  blacklisted      BOOLEAN NOT NULL DEFAULT false,     -- 2.6 安全规则命中标记，命中即对匹配服务不可见
  blacklist_reason TEXT,
  visit_count_90d  INT NOT NULL DEFAULT 0 CHECK (visit_count_90d >= 0),
  arrive_rate      REAL NOT NULL DEFAULT 1.0 CHECK (arrive_rate BETWEEN 0 AND 1),  -- <0.6 降权/下线(TRD 2.4)
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- 安全规则库（2.6 阻断级，配置中心热更新来源表） ----------
CREATE TABLE IF NOT EXISTS poi_safety_rule (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  city_code  TEXT NOT NULL DEFAULT '*',                -- '*'=全局，否则城市代码
  rule_type  TEXT NOT NULL CHECK (rule_type IN
              ('blacklist_category', 'blacklist_geom', 'night_allow', 'detour_factor', 'min_safety')),
  config     JSONB NOT NULL,                           -- 例: {"categories":["cemetery","construction"]}
                                                      --     {"wkt":"POLYGON(...)", "radius_m":50}
                                                      --     {"factor":1.35} / {"min_safety":80}
  version    INT NOT NULL,
  enabled    BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_rule UNIQUE (city_code, rule_type, version)
);
COMMENT ON TABLE poi_safety_rule IS
  '规则库服务端热更新；规则引擎在规则变更时批量刷新 poi.blacklisted。端上缓存最近一次规则版本用于离线兜底过滤。';

-- ---------- 结伴小组（TRD 2.5：同目的地、不共享位置，仅共享抵达事件） ----------
CREATE TABLE IF NOT EXISTS session_group (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invite_code CHAR(6) NOT NULL UNIQUE
              CONSTRAINT chk_invite_code CHECK (invite_code ~ '^[2-9A-HJ-NP-Z]{6}$'),  -- 去混淆字符 0/O/1/I
  created_by  UUID NOT NULL REFERENCES app_user(id),
  dest_poi_id BIGINT NOT NULL REFERENCES poi(id),       -- 全员同一目的地，各自独立会话
  expires_at  TIMESTAMPTZ NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- 盲盒步行会话 ----------
CREATE TABLE IF NOT EXISTS walk_session (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            UUID NOT NULL REFERENCES app_user(id),
  group_id           UUID REFERENCES session_group(id),
  poi_id             BIGINT REFERENCES poi(id),
  mode               session_mode_enum NOT NULL DEFAULT 'normal',
  start_geom         GEOMETRY(Point, 4326) NOT NULL,
  dest_geom_encrypted BYTEA,                           -- AES-256-GCM 密文（V1 加密下发；MVP 可 NULL）
  dest_nonce         BYTEA,                            -- GCM nonce(12B)
  dest_hint_bearing  REAL,                             -- 开盒仅下发: 目的地方位角(度, 正北=0)
  dest_hint_distance REAL,                             -- 开盒仅下发: 直线距离(米)，不含坐标
  target_distance_km REAL NOT NULL CHECK (target_distance_km BETWEEN 0.5 AND 10),
  status             session_status_enum NOT NULL DEFAULT 'walking',
  reroll_count       SMALLINT NOT NULL DEFAULT 0 CHECK (reroll_count BETWEEN 0 AND 3),  -- 换盒限 3 次/日
  started_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  ended_at           TIMESTAMPTZ,
  distance_walked_m  REAL NOT NULL DEFAULT 0 CHECK (distance_walked_m >= 0),
  steps              INT NOT NULL DEFAULT 0 CHECK (steps >= 0),
  CONSTRAINT chk_ended CHECK (status = 'walking' OR ended_at IS NOT NULL)  -- 终态必须有结束时间
);

-- ---------- 抵达事件（客户端触发 + 服务端二次校验，TRD 2.3） ----------
CREATE TABLE IF NOT EXISTS arrival_event (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  session_id      UUID NOT NULL UNIQUE REFERENCES walk_session(id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES app_user(id),
  poi_id          BIGINT NOT NULL REFERENCES poi(id),
  arrived_at      TIMESTAMPTZ NOT NULL,                -- UTC 存储
  server_verified BOOLEAN NOT NULL DEFAULT false,      -- 校验通过才点亮图鉴/计入排行
  confidence      REAL NOT NULL CHECK (confidence BETWEEN 0 AND 1),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- 轨迹审计（补传批量: 每 60s 或 10 点；90 天滚动删除） ----------
CREATE TABLE IF NOT EXISTS track_point (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  session_id  UUID NOT NULL REFERENCES walk_session(id) ON DELETE CASCADE,
  geom        GEOMETRY(Point, 4326) NOT NULL,
  accuracy_m  REAL,                                    -- GPS 水平精度
  speed_mps   REAL,                                    -- 端上瞬时速度
  step_count  INT,                                     -- 累计步数快照
  recorded_at TIMESTAMPTZ NOT NULL,                    -- 端上采集时间(UTC)
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
COMMENT ON TABLE track_point IS
  '90 天滚动删除: 每日 Cron 执行 DELETE FROM track_point WHERE recorded_at < now() - interval ''90 days'';';

-- ---------- 每日挑战（T+0 00:05 按区域生成，TRD 2.4/2.5） ----------
CREATE TABLE IF NOT EXISTS daily_challenge (
  date          DATE NOT NULL,
  region        TEXT NOT NULL,
  poi_id        BIGINT NOT NULL REFERENCES poi(id),
  arrival_count INT NOT NULL DEFAULT 0,                -- Redis INCR + 每日落库对账
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (date, region)
);

-- ============================================================
-- 类别参考数据（白名单单一事实来源，与原型 types.ts MODES 对齐）
-- ============================================================
INSERT INTO poi_category (category, description, night_allowed, surprise_boost, detour_class) VALUES
  ('park',            '公园绿地',                 false, 1.0, 'urban'),
  ('shrine',          '寺庙/教堂',                false, 1.6, 'urban'),
  ('museum',          '博物馆/美术馆',            false, 1.2, 'urban'),
  ('monument',        '纪念碑/城市雕塑',          false, 1.4, 'urban'),
  ('landmark_stone',  '石碑/铭牌/历史标记',       false, 1.8, 'urban'),   -- 稀有“秘境”类，w_serp 加成最高
  ('public_facility', '公共设施(图书馆/市民中心)', true,  1.0, 'urban'),
  ('plaza',           '广场',                     true,  1.1, 'urban'),
  ('convenience',     '便利店聚合点/车站',        true,  1.0, 'urban')
ON CONFLICT (category) DO NOTHING;

-- 黑名单类别（不可作为 POI 入库, 但 cemetery 等真实地名可能被抓取, 需可表达）
INSERT INTO poi_category (category, description, night_allowed, surprise_boost, detour_class) VALUES
  ('cemetery',   '墓地(黑名单, 仅用于阻断表达)',   false, 1.0, 'urban'),
  ('highway',    '高速沿线(黑名单, 仅用于阻断表达)', false, 1.0, 'urban'),
  ('construction','施工区(黑名单, 仅用于阻断表达)', false, 1.0, 'urban')
ON CONFLICT (category) DO NOTHING;
