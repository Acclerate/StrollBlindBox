# WalkBox 客户端定位模块 · 伪代码级详细设计（③ 交付物）

> 对应 TRD 2.2 客户端导航引擎 / NAV-01…06 / 2.3 围栏 / 定位精度策略。
> 技术基线：**Flutter 单代码库 + 原生定位插件桥接**（团队 <3 人选型），平台差异全部封装在
> `LocationService` 原生层；`LocatorCore` 及以上为纯 Dart，可单测、可仿真（原型已验证同构逻辑）。
> 本文伪代码中 `// [TRD NAV-xx]` 标注需求追溯。

---

## 1. 分层架构

```
┌────────────────────────────────────────────────────────┐
│ UI 层: 箭头渲染 / 距离显示 / 校准引导动画 / 揭晓动画        │
├────────────────────────────────────────────────────────┤
│ 领域层(Dart, 平台无关):                                  │
│   NavigationEngine(NAV-01/02)  GeofenceEngine(2.3)      │
│   MotionClassifier(NAV-06)     SessionStore(NAV-05)     │
│   TrackUploadQueue(2.3补传)                             │
├────────────────────────────────────────────────────────┤
│ LocatorCore(Dart, 平台无关核心状态机+滤波)                │
├────────────────────────────────────────────────────────┤
│ LocationService(原生): iOS CoreLocation / Android        │
│   FusedLocationProvider + StepSensor / Flutter插件桥     │
└────────────────────────────────────────────────────────┘
```

**数据流（单向）**：原生传感器 → `RawSample` 流 → `LocatorCore`（滤波/状态机）→
`LocationFix` 流 → 领域层（导航/围栏/记录）。UI 只订阅领域层，永不直接碰传感器。

```ts
interface RawSample {                    // 原生层上报的原始样本
  lat, lng, altitudeM
  accuracyM            // GPS 水平精度(1σ)
  speedMps             // 平台融合速度
  courseDeg?           // GPS 航向(仅运动时有意义)
  headingDeg?          // 磁罗盘航向
  headingAccuracyDeg?  // 罗盘精度
  magneticUT?          // 磁场强度(μT)
  stepCount?           // 传感器累计步数
  timestampMs
}

interface LocationFix {                 // LocatorCore 输出
  position             // 滤波后经纬度
  accuracyM            // 滤波后精度估计
  speedKmh, motion     // 'stationary'|'walking'|'suspicious'|'vehicle'  [NAV-06]
  headingDeg           // 融合航向(0..360)
  headingDegraded      // NAV-03 降级标记
  stepsTotal           // 有效累计步数
  timestampMs
}
```

## 2. 平台能力矩阵与插件接口

| 能力 | iOS (CoreLocation) | Android (FusedLocation) | 桥接接口 |
|---|---|---|---|
| 前台高精度流 | `desiredAccuracy=kCLLocationAccuracyNearestTenMeters` + `allowsBackgroundLocationUpdates=false` | `PRIORITY_HIGH_ACCURACY`, interval 1000ms | `startForeground()` / `stop()` |
| 后台低功耗 [NAV-04] | `startMonitoringSignificantLocationChanges` + 按需 `requestLocation()` 脉冲 | `PRIORITY_BALANCED_POWER_ACCURACY` + `setFastestInterval(30s)` | `startBackground()` |
| 航向 | `startUpdatingHeading`(CLHeading, 含 accuracy/磁场) | `SensorManager.TYPE_ROTATION_VECTOR`（无原生精度→用校准状态位） | `headingEvents` 流 |
| 步数 | `CMPedometer.queryPedometerData` | `TYPE_STEP_COUNTER`(硬件) / 加速度计软件计步兜底 | `stepEvents` 流 |
| GPS course | `CLLocation.course` + `courseAccuracy`(iOS13+) | `Location.getBearing()`（仅速度>阈值有效） | 含于 `RawSample` |
| 后台回收兜底 [NAV-04/05] | 显著位置变化唤醒进程 | 前台服务 `FOREGROUND_DATA_SYNC` | 见 §6 快照 |

**Flutter MethodChannel/EventChannel 契约**（`walkbox/location`）：

```
Methods:  requestPermission() -> 'granted'|'whenInUse'|'denied'
          requestBackgroundPermission() -> bool        // 独立申请+用途说明 [隐私合规]
          startForeground() / startBackground() / stop()
          calibrateCompassHint() -> void               // 触发系统8字校准动画
Events:   locationSamples: Stream<RawSample>           // EventChannel, 前台≥1Hz
          headingSamples:  Stream<RawSample.heading*>
          stepSamples:     Stream<int>
```

## 3. LocatorCore 状态机

```
states: IDLE → PERMISSION → ACTIVE(foreground) ⇄ ACTIVE(background) → STOPPED
         PERMISSION → (denied) → DEGRADED_MANUAL(仅手动刷新定位)
```

```pseudo
function onRawSample(s: RawSample):
  # ---- 1) 预过滤: 静态阈值 [定位精度策略] ----
  if s.accuracyM > 100:                     # 完全不可信样本
      drop(s); emitTelemetry('loc_dropped_low_accuracy'); return
  if isOutlier(s, lastAcceptedFix):         # 跳变 > 30km/h 点间速度(见原型 isGpsJump)
      outlierStreak += 1
      if outlierStreak <= 2: drop(s); return
      # 连续离群: 视为真实转移(如进隧道后重定位), 但标记精度降级
  else: outlierStreak = 0

  # ---- 2) 位置滤波: 位置低通 + 精度融合 ----
  if lastAcceptedFix == null or isOutlierReset:
      filtered = s.position
  else:
      w = clamp((last.accuracyM / s.accuracyM)^2, 0.2, 5)   # 精度反比加权
      filtered = lerp(lastAcceptedFix.position, s.position, 0.3 * w)
  accuracyEstimate = min(s.accuracyM, kalmanP(filtered))     # 取乐观但有界估计

  # ---- 3) 运动分类与计步 [NAV-06] ----
  speedKmh = s.speedMps * 3.6  (缺省: 由 Δposition/Δtime 推算, 窗口 5s 中位)
  motion = classifySpeed(speedKmh)
  #   <0.5 stationary | 0.5–12 walking | 12–30 suspicious | >30 vehicle
  if motion == 'walking': stepsTotal += sensorStepDelta
  #    suspicious/vehicle 段的步数增量全部丢弃(公交颠簸不计步)

  # ---- 4) 航向融合 [NAV-01] ----
  heading = fuseHeading(s, motion)          # 见 §4

  # ---- 5) 连续失锁判定 [定位精度策略] ----
  if now - lastGoodSampleTs > 30_000:
      freezeDistanceDisplay()               # “连续30s无定位不推进距离”
      emitEvent(NoFixFor30s)

  emit LocationFix{filtered, accuracyEstimate, speedKmh, motion, heading, stepsTotal, s.timestampMs}
```

## 4. 航向融合与罗盘降级（NAV-01 / NAV-03）

```pseudo
function fuseHeading(s: RawSample, motion): HeadingState:
  # --- 磁干扰检测(仅罗盘样本) ---
  if s.headingDeg != null:
      if s.magneticUT != null and s.magneticUT > 80:          # 磁场异常阈值(μT)
          return DEGRADED(reason='magnetic-interference', keep=lastGoodHeading)
      if s.headingAccuracyDeg != null and s.headingAccuracyDeg > 25:  # 未校准
          return DEGRADED(reason='uncalibrated', keep=lastGoodHeading)

  # --- 源选择: NAV-01 “静止用 GPS course, 行走用罗盘” ---
  if motion == 'walking' and s.headingDeg != null:
      raw = s.headingDeg                       # 罗盘优先(步频节拍下最灵敏)
      # 步进补偿(可选): 每步 ±8° 摆动, 以步频陷波进一步平滑
  else if motion != 'stationary' and s.courseDeg != null and courseValid(s):
      raw = s.courseDeg                        # GPS course: 骑行/车速下更稳
  else:
      return KEEP(lastGoodHeading)             # 静止且无有效罗盘: 保持

  # --- 圆周低通(α=0.2), 处理 359°↔1° 环绕 ---
  smoothed = lastGoodHeading == null ? raw
           : lastGoodHeading + 0.2 * angularDelta(raw, lastGoodHeading)
  lastGoodHeading = normalize0to360(smoothed)
  return OK(lastGoodHeading)

UI 渲染:
  arrowRotation = relativeBearing(destBearing, headingDeg)     # (-180,180], 10Hz 刷新 [NAV-01]
  if fix.accuracyM > 50: arrow.opacity = 0.4 + hint('信号弱，继续走')   # 降精度显示
  if heading.degraded:
      arrow 替换为静态指示: “目标在{bearingToClock(rel)}” + 8字校准引导动画  [NAV-03]
```

> 实现注记：iOS `CLHeading.headingAccuracy > 25°` 或磁场三轴模值偏离地磁基线 >80μT 判干扰；
> Android `ROTATION_VECTOR` 无精度字段，用 `SensorManager.getRotationMatrix` 置信度 +
> 校准回调（`CALIBRATION_REQUIRED`）等价映射到同一降级事件。

## 5. 后台续走与电量预算（NAV-04）

```pseudo
onAppBackground():
  native.stopForegroundStream()                       # 停 1Hz 高精度
  native.startSignificantChange()                     # iOS SLCS / Android balanced
  scheduleGpsPulse(every=30s)                         # 按需 GPS 脉冲, 间隔 ≥30s
  # 预算核算(验收: 后台1h耗电 <8%):
  #   30s 脉冲 × 120次/h ≈ 每次 GPS fix ~15s@~40mW + SLCS 待机 ~1mW
  #   罗盘在后台停流, 脉冲瞬间用 GPS course; 步数传感器常开(硬件计步 <1mW)
  #   Android: FOREGROUND_DATA_SYNC 前台服务 + PARTIAL_WAKE_LOCK(仅脉冲窗口)

onGpsPulse(fix):
  geofence.onLocationUpdate(toFix(fix))               # 围栏判定不降频(抵达可能发生在后台)
  sessionStore.appendTrack(fix)                       # 轨迹照常入队

onAppForeground():
  native.startForegroundStream()                      # 恢复 1Hz + 罗盘流
```

## 6. 会话快照与杀进程恢复（NAV-05）

```pseudo
SessionSnapshot(本地持久化, SQLCipher 表或加密JSON; 原型已验证字段):
  sessionId, mode, status='walking', startedAt, targetKm,
  destCipher (服务端AES-256-GCM密文+nonce, 端上永不解密存储),
  destHintBearing, destHintDistanceM,                 # 开盒仅有的两个导航量 [TRD 2.1]
  stepsTotal, distanceWalkedM, rulesVersion,          # 端上缓存规则版本作离线兜底 [TRD 2.6]
  pendingTrack: GpsFix[]                              # 未上传轨迹(离线补传队列)

写入协议(每次 LocationFix 后, 节流至≥2s一次):
  tmp = tmpfile(path); writeJSON(tmp, snapshot); fsync(tmp); rename(tmp, path)   # 原子写

启动恢复:
  if exists(session.json) and snapshot.status == 'walking':
      ui.showResumedWalkSession(snapshot.destHintBearing, snapshot.destHintDistanceM)
      resume track accumulation from snapshot.pendingTrack          # 100% 可恢复(验收)

触发快照的场景: 每2s节流写 / onAppBackground / 低电量告警 / 围栏状态迁移
```

## 7. 围栏判定接入（TRD 2.3，领域层）

引擎与原型 `geofence.ts` 同构，此处列端上特有部分：

```pseudo
onLocationFix(fix):                                    # 来自 LocatorCore(已滤波)
  verdict = geofence.onLocationUpdate(fix)             # 距离/置信度/乘车判定见原型
  case verdict:
    'vehicle' -> toast('这不像走路哦')                 # 乘车抵达不触发揭晓 [NAV-06]
    'nudge'   -> ui.showApproachHint()                 # “再靠近一点确认”
    'arrived' -> revealFlow()

revealFlow():                                          # 离线闭环 [TRD 1.1]
  confidence, tailTrack = fence.fuseResult()
  if offline:
      localReveal(cachedPoiBrief)                      # 会话开始时打包下发的简介
      enqueue(arrivalReport(sessionId, tailTrack, confidence))    # 恢复联网后补传
  else:
      POST /v1/sessions/{id}/arrive {trackSummary}
      -> 服务端 fn_verify_arrival 二次校验通过才正式揭晓+图鉴+排行
```

## 8. 补传队列（TRD 2.3）

```pseudo
TrackUploadQueue:
  enqueue(fix)                          # 每 fix 必入队(含后台脉冲)
  trigger: queue.size ≥ 10  OR  lastFlush ≥ 60s
  flush():
      POST /v1/sessions/{id}/track (batch)             # 批量: 每60s或10点
      on network error: keep queue, backoff 2^n s (max 5min), 持久化到快照
  上报内容: {points:[{lat,lng,accuracy,speed,steps,ts}], deviceTz}   # ts=UTC

端上埋点(接 Sentry/Grafana): 定位失败率 / 罗盘校准触发率 / 围栏nudge率 /
  vehicle拦截率 / 补传延迟P95 / 快照恢复次数      [TRD 五.可观测]
```

## 9. 降级矩阵（症状 → 策略）

| 症状 | 检测 | 策略 | 需求 |
|---|---|---|---|
| 权限仅“使用期间” | 系统权限位 | 核心闭环完整可玩；后台走 onActivityResult 引导 | 隐私合规 |
| 后台定位被拒 | 独立申请返回 | 锁屏时不续走，前台恢复后按快照续算 | NAV-04 |
| GPS 精度 >50m | fix.accuracy | 箭头半透明 + “信号弱”提示 | 定位精度策略 |
| 连续 30s 无定位 | lastGoodTs | 冻结距离显示，不推进 | 定位精度策略 |
| 磁干扰 | 磁场 >80μT | 静态点钟指示 + 校准动画；保留上次航向 | NAV-03 |
| 罗盘缺失(老设备) | 能力探测 | 全程 GPS course（步行时降频刷新 1Hz） | 五.兼容 |
| 速度 >30km/h | speed 分类 | 拦截揭晓 + 步数丢弃 | NAV-06 |
| 服务端不可达 | 请求失败 | 本地缓存 POI 池开盒、本地揭晓、补传 | 五.可用性 |
| 杀进程 | 重启检测快照 | 恢复会话与导航量(密文目的地) | NAV-05 |

## 10. 与原型的对应关系

| 本文档概念 | 原型实现（prototype/src） | 单测 |
|---|---|---|
| classifySpeed / stepsTotal | `motion.ts` | motion.test.ts |
| fuseHeading / 降级 | `compass.ts` | motion.test.ts |
| 围栏/置信度/补传 | `geofence.ts` `session.ts` | geofence.test.ts |
| 原子快照/恢复 | `session.ts SessionStore` | demo ④ 段 |
| angularDelta/relativeBearing | `geo.ts` `compass.ts` | geo/motion.test.ts |

原型 36 项单测即本设计的可执行规格说明；实现原生插件时以同构测试用例做回归基线。
