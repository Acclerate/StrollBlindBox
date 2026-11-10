# WalkBox（散步盲盒）· 技术交付实现

基于《散步盲盒 App 技术实现需求说明书（TRD）V1.0》的交付实现：

| # | 交付物 | 位置 | 状态 |
|---|---|---|---|
| ① | 数据库完整 DDL + 种子 POI 导入脚本设计 | [`db/`](db/) | ✅ 已在 PostGIS 16 实测 |
| ② | 匹配算法与围栏判定的可运行原型 | [`prototype/`](prototype/) | ✅ 36 项单测全绿 + 闭环实跑 |
| ③ | 客户端定位模块伪代码级详细设计 | [`docs/client-location-design.md`](docs/client-location-design.md) | ✅ |
| ④ | **App（Flutter Android）+ 后端 API** | [`app/`](app/) · [`server/`](server/) | ✅ MVP 核心闭环 |

```
├── docker-compose.yml          # PostGIS 16 + PostGIS 3.4（127.0.0.1:54329）
├── app/                        # ④ Flutter App（Android, 核心闭环）
│   ├── lib/core/               #   geo/motion/fence — 原型 TS 逻辑的 Dart 移植(同基线单测)
│   ├── lib/state/              #   WalkboxController — LocatorCore 编排(详设§3-§7落地)
│   ├── lib/ui/                 #   首页开盒 / 箭头导航 / 抵达揭晓 / 图鉴
│   └── test/core_test.dart     #   14 项 Dart 单测
├── server/                     # ④ 后端 API（TRD 四. 接口子集, 复用 prototype 逻辑）
│   └── src/index.ts            #   POST /v1/sessions · /arrive · /quit · /reroll · GET /v1/records
├── db/
│   ├── schema/
│   │   ├── 001_extensions.sql  # postgis + pgcrypto
│   │   ├── 002_tables.sql      # 8 表完整 DDL: app_user/poi_category/poi/poi_safety_rule/
│   │   │                       #   session_group/walk_session/arrival_event/track_point/daily_challenge
│   │   ├── 003_indexes.sql     # GIST(geography 生成列, 部分索引)等 + 用途注释
│   │   └── 004_views_functions.sql
│   │       ├── v_poi_active    #   安全视图: 匹配服务唯一可见入口（黑名单/抵达率过滤）
│   │       ├── fn_match_candidates        # 候选查询(ST_DWithin, 与原型语义一致)
│   │       ├── fn_verify_arrival          # 服务端抵达二次校验（轨迹末端 vs 围栏）
│   │       ├── fn_settle_daily_challenge  # Redis→DB 每日对账
│   │       └── fn_refresh_blacklist       # 规则库热更新→批量刷新黑名单标记
│   ├── seed/
│   │   ├── gen_seed_pois.mjs   # 确定性生成器(PRNG seed=20261110): 上海 500 POI
│   │   │                       #   含 30 黑名单样本(其中 16 个由规则热更新刷出)/
│   │   │                       #   20 ferry_gap 跨江标记/20 待审核/20 低抵达率
│   │   ├── seed_pois.sql|.csv  # 生成产物（SQL 幂等 / CSV 供 \copy 管道）
│   │   └── import_csv.sql      # 真实数据集导入通道: staging 表 + 校验 + 幂等入库
│   └── verify.sql              # DDL+种子抽查（V1–V7, 含索引执行计划与函数冒烟）
├── prototype/                  # TypeScript, Node ≥22.6 原生运行 .ts（零构建）
│   ├── src/                    # 见下表
│   └── test/                   # 36 项 node:test 单测, 逐条标注 TRD 需求编号
└── docs/client-location-design.md
```

## 快速开始

### 1) 数据库（可选，原型默认内存数据源）

```bash
docker compose up -d                    # 起 PostGIS（127.0.0.1:54329, walkbox/walkbox_dev）
for f in db/schema/00{1,2,3,4}_*.sql db/seed/seed_pois.sql; do
  docker exec -i walkbox-postgis psql -U walkbox -d walkbox -v ON_ERROR_STOP=1 -q -f - < "$f"
done
docker exec -i walkbox-postgis psql -U walkbox -d walkbox -f - < db/verify.sql   # V1–V7 全过
```

种子再生成（确定性，可复现）：`node db/seed/gen_seed_pois.mjs`
真实数据集替换：整理为同构 CSV 后走 `db/seed/import_csv.sql`（staging + 校验 + 幂等）。

### 2) 原型（无需数据库）

```bash
cd prototype
npm test                # 36 项单测（不依赖 DB）
npm run demo            # 开盒→步行模拟→围栏判定→揭晓 全闭环（内存 POI 池）
npm run demo -- --night # 夜间模式: 候选池 26→3（22:00–05:00 仅 24h 类别）
npm run demo -- --ride  # 乘车段拦截: "这不像走路哦"，步数不计、抵达不揭晓
npm run demo -- --reroll# 换盒限流: 3 次/日
npm i && npm run demo:db# 连真实 PostGIS（ST_DWithin 候选, 与 SQL 端结果一致）
```

### 3) App + 后端（④ · MVP 核心闭环）

```bash
# 后端（默认内存 POI 池; WALKBOX_DB=1 连 PostGIS）
cd server && npm start            # :8081（0.0.0.0）, 图鉴持久化到 server/data/records.json
npm run e2e                       # 服务端 e2e（鉴权/限流/校验/图鉴/reroll 全路径）

# App（Flutter Android）
cd ../app
flutter test                      # 14 项 Dart 单测（geo/motion/fence 与 TS 原型同基线）
flutter build apk --debug         # 产物: build/app/outputs/flutter-apk/app-debug.apk
adb install build/app/outputs/flutter-apk/app-debug.apk
adb reverse tcp:8081 tcp:8081     # 真机经 USB 访问本机后端（App 内服务器地址保持 127.0.0.1:8081）
```

真机走测：开盒 → 按箭头步行 → 30m 围栏 + 置信度≥0.8 触发揭晓 → 图鉴；换盒 3 次/日、开盒 10 次/时、乘车拦截（>30km/h）、罗盘不稳降级为"X 点钟方向"、弱信号提示、杀进程恢复全部内置。

CN 网络对策（已配置在仓库内）：gradle wrapper 走腾讯镜像（`android/gradle/wrapper/`），Maven 走阿里云镜像（`android/settings.gradle.kts` + `build.gradle.kts`），pub 走 flutter-io.cn（命令行环境变量）。

## 原型模块 ↔ TRD 需求对照

| 模块 | 职责 | TRD |
|---|---|---|
| `geo.ts` | Haversine / 方位角 / NAV-02 距离格式 / **目的地 AES-256-GCM 加密下发** | 2.1 输出约束, NAV-02, 三. |
| `types.ts` | 模式配置（普通/海外/夜间: 类别白名单、安全阈值、绕转系数） | 2.1 |
| `safety.ts` | 安全过滤引擎: 黑名单类别/夜间窗口(22–05)/accessibility 不可达/规则版本 | 2.6 阻断级 |
| `poiSource.ts` | 候选查询接口; InMemory(种子) 与 PostGIS(`ST_DWithin`) 双实现, 语义对齐 `fn_match_candidates` | 2.1 步骤1 |
| `matcher.ts` | 候选(D×1.2)→硬过滤(30天去重/不可达/距离修正窗 [0.8D,1.3D] 逐级放宽)→加权随机 `w_cold×w_serp×w_quality`→Places 兜底; 开盒限流 10/h、reroll 3/日 | 2.1 全流程, 四. |
| `geofence.ts` | 围栏判定: 距离≤fence 时置信度融合 `0.4·GPS精度+0.35·轨迹+0.25·步数 ≥0.8`; 乘车优先拦截; 服务端二次校验镜像 | 2.3, NAV-06 |
| `motion.ts` | 速度分类 0.5–12/12–30/>30 km/h; 仅步行区间计步 | NAV-06 |
| `compass.ts` | 静止用 GPS course/行走用罗盘+圆周低通; 磁干扰(>80μT)/未校准(>25°)降级; 点钟方向静态指示 | NAV-01/03 |
| `session.ts` | 快照原子写(tmp+rename)/杀进程恢复/密文目的地持久化/补传队列(60s或10点) | NAV-05, 2.3 |
| `cli.ts` | 端到端演示: 限流→开盒(不揭晓)→快照→恢复→步行模拟(GPS噪声)→围栏→服务端校验→揭晓 | 全链路 |

## 验证记录（本仓库交付前实跑）

| 验证项 | 命令 | 结果 |
|---|---|---|
| DDL 干净安装 | drop schema → 001–004 + seed | ✅ 一次通过（修复 `GET DIAGNOSTICS` 语法后） |
| 安全过滤回归 | `verify.sql` V1: 视图黑名单命中 | ✅ **0**（TRD 六.5 阻断线） |
| 数据分布 | V2 | ✅ 500 / 黑名单30 / 可见430 / 待审核20 |
| 候选查询走索引 | V5 EXPLAIN | ✅ `Index Scan using idx_poi_geog_active` |
| 规则热更新 | seed 内 `fn_refresh_blacklist()` | ✅ 刷出 16 条(construction/island/rail) |
| 抵达二次校验 | V6 DO 块 | ✅ true + server_verified 回写 |
| CSV 导入通道 | `import_csv.sql` | ✅ staged 500 / rejected 0 / 幂等 |
| 单元测试 | `npm test` | ✅ 36/36（含 TRD 六.2 围栏误判专项子集: 河对岸漂移/低精度/乘车 误判率=0） |
| 闭环演示 | `demo` / `--night` / `--ride` / `--reroll` / `--db` | ✅ 全部实跑通过 |

## 设计要点（与 TRD 的对应决策）

1. **geography 生成列索引**：米制 `ST_DWithin` 查询走 `geog` 生成列上的部分 GIST 索引
   （`WHERE status='active'`）；`geom` 上的 GIST 保留给管理后台度域查询——两者互不替代。
2. **黑名单双通道**：`blacklisted` 标记（数据级，查询快）+ `poi_safety_rule` 规则库
   （配置中心热更新，`fn_refresh_blacklist()` 批量刷标记），规则命中对匹配服务即刻不可见。
3. **不提前揭晓**：开盒只返回方位角+直线距离；目的地密文（AES-256-GCM）落库
   `dest_geom_encrypted/dest_nonce`，端上快照同样只存密文；服务端校验通过才解密揭晓。
4. **双数据源同构**：InMemory 与 PostGIS 两个 `PoiSource` 过滤语义逐条对齐
   （可见性/夜间/抵达率清理线/黑名单刷新）。CSV 加载器镜像 `fn_refresh_blacklist()`
   的 accessibility 联动（island/铁路沿线 → 黑名单），实测 `demo` 与 `demo:db`
   候选池计数完全一致（24=24，与 SQL 端 `fn_match_candidates` 相同）。
5. **围栏防误判三层**：距离门限（≤fence）→ 置信度融合（GPS 精度/近60s轨迹/步数增量）→
   服务端轨迹末端二次校验；乘车(>30km/h)在最先处拦截。

## 技术栈

Node.js 26（原生 TS type-stripping，零构建）· node:test · PostgreSQL 16 + PostGIS 3.4（Docker）· pg（可选依赖）
