-- WalkBox 种子 POI（由 gen_seed_pois.mjs 生成, PRNG seed=20261110, 共 500 条）
-- 幂等: ON CONFLICT (source_ref) DO NOTHING
BEGIN;

-- 安全规则: blacklist_category（construction 依赖 fn_refresh_blacklist() 热更新应用）
INSERT INTO poi_safety_rule (city_code, rule_type, config, version, enabled) VALUES
  ('*', 'blacklist_category', '{"categories":["cemetery","highway","construction"]}'::jsonb, 1, true),
  ('*', 'night_allow',        '{"note":"22:00-05:00 仅 open_24h 类别, 见 fn_match_candidates"}'::jsonb, 1, true),
  ('*', 'detour_factor',      '{"urban":1.35,"suburb":1.25,"rural":1.2}'::jsonb, 1, true)
ON CONFLICT DO NOTHING;

INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.504332, 31.167469), 4326),
  'Park-001', '滨江小园 001', 'park', '滨江小园 001（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0001',
  3, 67, '{}'::jsonb, 60, 'active', false,
  false, NULL, 4, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.530357, 31.272702), 4326),
  'Park-002', '梧桐绿地 002', 'park', '梧桐绿地 002（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0002',
  3, 71, '{}'::jsonb, 60, 'active', false,
  false, NULL, 31, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.441742, 31.165789), 4326),
  'Park-003', '滨江小园 003', 'park', '滨江小园 003（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0003',
  3, 56, '{}'::jsonb, 60, 'active', false,
  false, NULL, 65, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.429543, 31.222766), 4326),
  'Park-004', '梧桐绿地 004', 'park', '梧桐绿地 004（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0004',
  4, 91, '{}'::jsonb, 60, 'active', false,
  false, NULL, 30, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.496828, 31.183431), 4326),
  'Park-005', '口袋公园 005', 'park', '口袋公园 005（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0005',
  5, 57, '{}'::jsonb, 60, 'active', false,
  false, NULL, 2, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.452730, 31.278468), 4326),
  'Park-006', '梧桐绿地 006', 'park', '梧桐绿地 006（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0006',
  4, 64, '{}'::jsonb, 60, 'active', false,
  false, NULL, 38, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.515132, 31.282689), 4326),
  'Park-007', '街心花园 007', 'park', '街心花园 007（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0007',
  4, 84, '{}'::jsonb, 60, 'active', false,
  false, NULL, 23, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.416323, 31.197252), 4326),
  'Park-008', '梧桐绿地 008', 'park', '梧桐绿地 008（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0008',
  3, 68, '{}'::jsonb, 60, 'active', false,
  false, NULL, 20, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.528941, 31.230575), 4326),
  'Park-009', '社区花园 009', 'park', '社区花园 009（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0009',
  4, 75, '{}'::jsonb, 60, 'active', false,
  false, NULL, 30, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.448338, 31.295074), 4326),
  'Park-010', '口袋公园 010', 'park', '口袋公园 010（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0010',
  4, 58, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.551466, 31.275197), 4326),
  'Park-011', '街心花园 011', 'park', '街心花园 011（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0011',
  4, 83, '{}'::jsonb, 60, 'active', false,
  false, NULL, 8, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.421475, 31.278851), 4326),
  'Park-012', '滨江小园 012', 'park', '滨江小园 012（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0012',
  4, 88, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.98)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.563599, 31.283337), 4326),
  'Park-013', '街心花园 013', 'park', '街心花园 013（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0013',
  3, 61, '{}'::jsonb, 60, 'active', false,
  false, NULL, 28, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.430018, 31.206845), 4326),
  'Park-014', '街心花园 014', 'park', '街心花园 014（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0014',
  4, 73, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.506792, 31.241303), 4326),
  'Park-015', '口袋公园 015', 'park', '口袋公园 015（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0015',
  3, 68, '{}'::jsonb, 60, 'active', false,
  false, NULL, 8, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.451938, 31.138744), 4326),
  'Park-016', '街心花园 016', 'park', '街心花园 016（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0016',
  3, 81, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.499074, 31.308490), 4326),
  'Park-017', '口袋公园 017', 'park', '口袋公园 017（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0017',
  3, 83, '{}'::jsonb, 60, 'active', false,
  false, NULL, 29, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.515284, 31.304436), 4326),
  'Park-018', '社区花园 018', 'park', '社区花园 018（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0018',
  4, 84, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.535149, 31.162140), 4326),
  'Park-019', '街心花园 019', 'park', '街心花园 019（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0019',
  3, 56, '{}'::jsonb, 60, 'active', false,
  false, NULL, 18, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.481599, 31.286411), 4326),
  'Park-020', '社区花园 020', 'park', '社区花园 020（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0020',
  4, 56, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.406492, 31.192412), 4326),
  'Park-021', '口袋公园 021', 'park', '口袋公园 021（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0021',
  3, 61, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.486637, 31.267778), 4326),
  'Park-022', '口袋公园 022', 'park', '口袋公园 022（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0022',
  3, 63, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.501410, 31.208400), 4326),
  'Park-023', '社区花园 023', 'park', '社区花园 023（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0023',
  2, 66, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.524093, 31.195284), 4326),
  'Park-024', '梧桐绿地 024', 'park', '梧桐绿地 024（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0024',
  3, 72, '{}'::jsonb, 60, 'active', false,
  false, NULL, 1, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.523293, 31.316903), 4326),
  'Park-025', '街心花园 025', 'park', '街心花园 025（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0025',
  3, 69, '{}'::jsonb, 60, 'active', false,
  false, NULL, 85, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.556992, 31.235877), 4326),
  'Park-026', '街心花园 026', 'park', '街心花园 026（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0026',
  3, 80, '{}'::jsonb, 60, 'active', false,
  false, NULL, 2, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.538334, 31.272800), 4326),
  'Park-027', '滨江小园 027', 'park', '滨江小园 027（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0027',
  3, 84, '{}'::jsonb, 60, 'active', false,
  false, NULL, 3, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.459182, 31.231559), 4326),
  'Park-028', '口袋公园 028', 'park', '口袋公园 028（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0028',
  3, 77, '{}'::jsonb, 60, 'active', false,
  false, NULL, 14, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.580059, 31.263732), 4326),
  'Park-029', '梧桐绿地 029', 'park', '梧桐绿地 029（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0029',
  3, 64, '{}'::jsonb, 60, 'active', false,
  false, NULL, 4, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.478180, 31.168907), 4326),
  'Park-030', '社区花园 030', 'park', '社区花园 030（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0030',
  3, 86, '{}'::jsonb, 60, 'active', false,
  false, NULL, 39, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.403907, 31.152561), 4326),
  'Park-031', '口袋公园 031', 'park', '口袋公园 031（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0031',
  3, 88, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.437901, 31.160082), 4326),
  'Park-032', '社区花园 032', 'park', '社区花园 032（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0032',
  3, 55, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.567942, 31.232858), 4326),
  'Park-033', '梧桐绿地 033', 'park', '梧桐绿地 033（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0033',
  4, 82, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.465777, 31.222165), 4326),
  'Park-034', '口袋公园 034', 'park', '口袋公园 034（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0034',
  3, 68, '{}'::jsonb, 60, 'active', false,
  false, NULL, 38, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.559903, 31.184642), 4326),
  'Park-035', '梧桐绿地 035', 'park', '梧桐绿地 035（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0035',
  4, 70, '{}'::jsonb, 60, 'active', false,
  false, NULL, 31, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.558893, 31.263957), 4326),
  'Park-036', '社区花园 036', 'park', '社区花园 036（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0036',
  3, 67, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.444097, 31.211187), 4326),
  'Park-037', '梧桐绿地 037', 'park', '梧桐绿地 037（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0037',
  4, 95, '{}'::jsonb, 60, 'active', false,
  false, NULL, 11, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.569773, 31.193715), 4326),
  'Park-038', '滨江小园 038', 'park', '滨江小园 038（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0038',
  3, 86, '{}'::jsonb, 60, 'active', false,
  false, NULL, 8, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.438725, 31.259610), 4326),
  'Park-039', '社区花园 039', 'park', '社区花园 039（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0039',
  3, 90, '{}'::jsonb, 60, 'active', false,
  false, NULL, 33, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.547431, 31.223477), 4326),
  'Park-040', '口袋公园 040', 'park', '口袋公园 040（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0040',
  3, 79, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.553200, 31.227466), 4326),
  'Park-041', '梧桐绿地 041', 'park', '梧桐绿地 041（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0041',
  3, 80, '{}'::jsonb, 60, 'active', false,
  false, NULL, 114, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.501036, 31.141073), 4326),
  'Park-042', '社区花园 042', 'park', '社区花园 042（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0042',
  3, 58, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.568713, 31.270322), 4326),
  'Park-043', '滨江小园 043', 'park', '滨江小园 043（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0043',
  3, 88, '{}'::jsonb, 60, 'active', false,
  false, NULL, 17, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.561814, 31.199876), 4326),
  'Park-044', '街心花园 044', 'park', '街心花园 044（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0044',
  3, 56, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.523496, 31.148183), 4326),
  'Park-045', '滨江小园 045', 'park', '滨江小园 045（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0045',
  3, 88, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.485113, 31.307153), 4326),
  'Park-046', '口袋公园 046', 'park', '口袋公园 046（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0046',
  2, 57, '{}'::jsonb, 60, 'active', false,
  false, NULL, 4, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.526760, 31.153109), 4326),
  'Park-047', '社区花园 047', 'park', '社区花园 047（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0047',
  4, 79, '{}'::jsonb, 60, 'active', false,
  false, NULL, 73, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.449824, 31.216298), 4326),
  'Park-048', '街心花园 048', 'park', '街心花园 048（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0048',
  4, 69, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.560711, 31.172115), 4326),
  'Park-049', '街心花园 049', 'park', '街心花园 049（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0049',
  4, 82, '{}'::jsonb, 60, 'active', false,
  false, NULL, 7, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.571033, 31.191697), 4326),
  'Park-050', '街心花园 050', 'park', '街心花园 050（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0050',
  2, 69, '{}'::jsonb, 60, 'active', false,
  false, NULL, 8, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.567938, 31.175078), 4326),
  'Park-051', '梧桐绿地 051', 'park', '梧桐绿地 051（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0051',
  4, 71, '{}'::jsonb, 60, 'active', false,
  false, NULL, 1, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.496140, 31.324709), 4326),
  'Park-052', '梧桐绿地 052', 'park', '梧桐绿地 052（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0052',
  4, 55, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.493369, 31.288569), 4326),
  'Park-053', '口袋公园 053', 'park', '口袋公园 053（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0053',
  3, 61, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.492969, 31.156884), 4326),
  'Park-054', '社区花园 054', 'park', '社区花园 054（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0054',
  3, 87, '{}'::jsonb, 60, 'active', false,
  false, NULL, 1, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.439731, 31.195403), 4326),
  'Park-055', '口袋公园 055', 'park', '口袋公园 055（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0055',
  4, 92, '{}'::jsonb, 60, 'active', false,
  false, NULL, 8, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.456990, 31.171108), 4326),
  'Park-056', '口袋公园 056', 'park', '口袋公园 056（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0056',
  3, 57, '{}'::jsonb, 60, 'active', false,
  false, NULL, 9, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.426819, 31.197270), 4326),
  'Park-057', '滨江小园 057', 'park', '滨江小园 057（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0057',
  3, 67, '{}'::jsonb, 60, 'active', false,
  false, NULL, 15, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.393790, 31.234154), 4326),
  'Park-058', '街心花园 058', 'park', '街心花园 058（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0058',
  4, 61, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.431648, 31.208567), 4326),
  'Park-059', '街心花园 059', 'park', '街心花园 059（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0059',
  4, 75, '{}'::jsonb, 60, 'active', false,
  false, NULL, 26, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.428250, 31.177039), 4326),
  'Park-060', '滨江小园 060', 'park', '滨江小园 060（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0060',
  3, 55, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.483088, 31.234237), 4326),
  'Park-061', '街心花园 061', 'park', '街心花园 061（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0061',
  4, 60, '{}'::jsonb, 60, 'active', false,
  false, NULL, 3, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.390910, 31.275045), 4326),
  'Park-062', '街心花园 062', 'park', '街心花园 062（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0062',
  3, 95, '{}'::jsonb, 60, 'active', false,
  false, NULL, 25, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.403481, 31.255143), 4326),
  'Park-063', '社区花园 063', 'park', '社区花园 063（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0063',
  4, 81, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.437202, 31.210196), 4326),
  'Park-064', '口袋公园 064', 'park', '口袋公园 064（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0064',
  3, 87, '{}'::jsonb, 60, 'active', false,
  false, NULL, 16, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.553592, 31.278428), 4326),
  'Park-065', '梧桐绿地 065', 'park', '梧桐绿地 065（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0065',
  3, 61, '{}'::jsonb, 60, 'active', false,
  false, NULL, 14, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.378356, 31.277561), 4326),
  'Park-066', '梧桐绿地 066', 'park', '梧桐绿地 066（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0066',
  3, 72, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.425420, 31.250682), 4326),
  'Park-067', '梧桐绿地 067', 'park', '梧桐绿地 067（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0067',
  3, 67, '{}'::jsonb, 60, 'active', false,
  false, NULL, 36, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.452582, 31.247278), 4326),
  'Park-068', '社区花园 068', 'park', '社区花园 068（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0068',
  4, 66, '{}'::jsonb, 60, 'active', false,
  false, NULL, 8, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.369711, 31.207379), 4326),
  'Park-069', '社区花园 069', 'park', '社区花园 069（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0069',
  3, 90, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.585720, 31.230096), 4326),
  'Park-070', '滨江小园 070', 'park', '滨江小园 070（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0070',
  3, 84, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476935, 31.183104), 4326),
  'Park-071', '口袋公园 071', 'park', '口袋公园 071（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0071',
  4, 73, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.528878, 31.306122), 4326),
  'Park-072', '口袋公园 072', 'park', '口袋公园 072（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0072',
  4, 78, '{}'::jsonb, 60, 'active', false,
  false, NULL, 22, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.449909, 31.242597), 4326),
  'Park-073', '街心花园 073', 'park', '街心花园 073（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0073',
  4, 86, '{}'::jsonb, 60, 'active', false,
  false, NULL, 7, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.534918, 31.213505), 4326),
  'Park-074', '梧桐绿地 074', 'park', '梧桐绿地 074（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0074',
  5, 89, '{}'::jsonb, 60, 'active', false,
  false, NULL, 18, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.390195, 31.213963), 4326),
  'Park-075', '街心花园 075', 'park', '街心花园 075（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0075',
  3, 68, '{}'::jsonb, 60, 'active', false,
  false, NULL, 27, 0.67)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.423892, 31.225163), 4326),
  'Park-076', '社区花园 076', 'park', '社区花园 076（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0076',
  4, 58, '{}'::jsonb, 60, 'active', false,
  false, NULL, 16, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.400134, 31.226750), 4326),
  'Park-077', '梧桐绿地 077', 'park', '梧桐绿地 077（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0077',
  3, 78, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.393309, 31.243064), 4326),
  'Park-078', '口袋公园 078', 'park', '口袋公园 078（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0078',
  4, 67, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.413722, 31.228450), 4326),
  'Park-079', '滨江小园 079', 'park', '滨江小园 079（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0079',
  3, 58, '{}'::jsonb, 60, 'active', false,
  false, NULL, 28, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.411910, 31.247847), 4326),
  'Park-080', '滨江小园 080', 'park', '滨江小园 080（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0080',
  4, 73, '{}'::jsonb, 60, 'active', false,
  false, NULL, 20, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.429654, 31.313101), 4326),
  'Park-081', '社区花园 081', 'park', '社区花园 081（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0081',
  3, 75, '{}'::jsonb, 60, 'active', false,
  false, NULL, 27, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.474655, 31.155016), 4326),
  'Park-082', '滨江小园 082', 'park', '滨江小园 082（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0082',
  4, 73, '{}'::jsonb, 60, 'active', false,
  false, NULL, 31, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.412306, 31.150260), 4326),
  'Park-083', '社区花园 083', 'park', '社区花园 083（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0083',
  4, 73, '{}'::jsonb, 60, 'active', false,
  false, NULL, 11, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.513611, 31.249059), 4326),
  'Park-084', '社区花园 084', 'park', '社区花园 084（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0084',
  4, 76, '{}'::jsonb, 60, 'active', false,
  false, NULL, 27, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.442045, 31.239028), 4326),
  'Park-085', '街心花园 085', 'park', '街心花园 085（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0085',
  3, 60, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.502146, 31.266850), 4326),
  'Park-086', '梧桐绿地 086', 'park', '梧桐绿地 086（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0086',
  5, 75, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.400571, 31.247874), 4326),
  'Park-087', '滨江小园 087', 'park', '滨江小园 087（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0087',
  3, 65, '{}'::jsonb, 60, 'active', false,
  false, NULL, 38, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.389511, 31.201127), 4326),
  'Park-088', '街心花园 088', 'park', '街心花园 088（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0088',
  4, 78, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.446429, 31.202147), 4326),
  'Park-089', '口袋公园 089', 'park', '口袋公园 089（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0089',
  4, 85, '{}'::jsonb, 60, 'active', false,
  false, NULL, 34, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.557624, 31.259766), 4326),
  'Park-090', '口袋公园 090', 'park', '口袋公园 090（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0090',
  4, 70, '{}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.472001, 31.214800), 4326),
  'Temple-091', '老城隍庙 091', 'shrine', '老城隍庙 091（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0091',
  3, 86, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.382649, 31.207743), 4326),
  'Temple-092', '静安别院 092', 'shrine', '静安别院 092（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0092',
  4, 90, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.563119, 31.238746), 4326),
  'Temple-093', '土地庙 093', 'shrine', '土地庙 093（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0093',
  3, 66, '{}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.425114, 31.201755), 4326),
  'Temple-094', '静安别院 094', 'shrine', '静安别院 094（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0094',
  4, 89, '{}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.494333, 31.262403), 4326),
  'Temple-095', '静安别院 095', 'shrine', '静安别院 095（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0095',
  4, 80, '{}'::jsonb, 30, 'active', false,
  false, NULL, 2, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.522878, 31.164012), 4326),
  'Temple-096', '土地庙 096', 'shrine', '土地庙 096（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0096',
  3, 76, '{}'::jsonb, 30, 'active', false,
  false, NULL, 35, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.564208, 31.278465), 4326),
  'Temple-097', '静安别院 097', 'shrine', '静安别院 097（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0097',
  3, 65, '{}'::jsonb, 30, 'active', false,
  false, NULL, 97, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.398868, 31.219663), 4326),
  'Temple-098', '老城隍庙 098', 'shrine', '老城隍庙 098（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0098',
  4, 62, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.560662, 31.284595), 4326),
  'Temple-099', '观音堂 099', 'shrine', '观音堂 099（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0099',
  4, 78, '{}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.434363, 31.253115), 4326),
  'Temple-100', '观音堂 100', 'shrine', '观音堂 100（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0100',
  3, 67, '{}'::jsonb, 30, 'active', false,
  false, NULL, 30, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.397912, 31.235607), 4326),
  'Temple-101', '静安别院 101', 'shrine', '静安别院 101（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0101',
  3, 80, '{}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.499622, 31.324930), 4326),
  'Temple-102', '老城隍庙 102', 'shrine', '老城隍庙 102（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0102',
  3, 81, '{}'::jsonb, 30, 'active', false,
  false, NULL, 66, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.560919, 31.263481), 4326),
  'Temple-103', '土地庙 103', 'shrine', '土地庙 103（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0103',
  4, 75, '{}'::jsonb, 30, 'active', false,
  false, NULL, 10, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.494735, 31.198335), 4326),
  'Temple-104', '土地庙 104', 'shrine', '土地庙 104（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0104',
  4, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 11, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.475512, 31.148988), 4326),
  'Temple-105', '土地庙 105', 'shrine', '土地庙 105（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0105',
  4, 77, '{}'::jsonb, 30, 'active', false,
  false, NULL, 19, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.387896, 31.258401), 4326),
  'Temple-106', '老城隍庙 106', 'shrine', '老城隍庙 106（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0106',
  3, 53, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.528261, 31.233796), 4326),
  'Temple-107', '基督教堂 107', 'shrine', '基督教堂 107（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0107',
  3, 76, '{}'::jsonb, 30, 'active', false,
  false, NULL, 83, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.423099, 31.298626), 4326),
  'Temple-108', '土地庙 108', 'shrine', '土地庙 108（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0108',
  4, 53, '{}'::jsonb, 30, 'active', false,
  false, NULL, 27, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.564861, 31.187885), 4326),
  'Temple-109', '静安别院 109', 'shrine', '静安别院 109（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0109',
  3, 59, '{}'::jsonb, 30, 'active', false,
  false, NULL, 1, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.368167, 31.255214), 4326),
  'Temple-110', '土地庙 110', 'shrine', '土地庙 110（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0110',
  4, 83, '{}'::jsonb, 30, 'active', false,
  false, NULL, 19, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.574958, 31.253999), 4326),
  'Temple-111', '土地庙 111', 'shrine', '土地庙 111（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0111',
  3, 73, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.453134, 31.299253), 4326),
  'Temple-112', '老城隍庙 112', 'shrine', '老城隍庙 112（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0112',
  3, 55, '{}'::jsonb, 30, 'active', false,
  false, NULL, 38, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.544288, 31.250702), 4326),
  'Temple-113', '观音堂 113', 'shrine', '观音堂 113（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0113',
  3, 65, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.469750, 31.220272), 4326),
  'Temple-114', '基督教堂 114', 'shrine', '基督教堂 114（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0114',
  4, 75, '{}'::jsonb, 30, 'active', false,
  false, NULL, 8, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.497796, 31.268836), 4326),
  'Temple-115', '土地庙 115', 'shrine', '土地庙 115（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0115',
  4, 52, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.413040, 31.221889), 4326),
  'Temple-116', '基督教堂 116', 'shrine', '基督教堂 116（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0116',
  3, 85, '{}'::jsonb, 30, 'active', false,
  false, NULL, 17, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.558132, 31.227844), 4326),
  'Temple-117', '土地庙 117', 'shrine', '土地庙 117（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0117',
  3, 86, '{}'::jsonb, 30, 'active', false,
  false, NULL, 33, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.408471, 31.161814), 4326),
  'Temple-118', '基督教堂 118', 'shrine', '基督教堂 118（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0118',
  4, 85, '{}'::jsonb, 30, 'active', false,
  false, NULL, 17, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.407976, 31.166453), 4326),
  'Temple-119', '老城隍庙 119', 'shrine', '老城隍庙 119（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0119',
  3, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 18, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.481851, 31.247063), 4326),
  'Temple-120', '老城隍庙 120', 'shrine', '老城隍庙 120（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0120',
  4, 86, '{}'::jsonb, 30, 'active', false,
  false, NULL, 17, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.533313, 31.313906), 4326),
  'Temple-121', '老城隍庙 121', 'shrine', '老城隍庙 121（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0121',
  4, 62, '{}'::jsonb, 30, 'active', false,
  false, NULL, 5, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.396877, 31.240218), 4326),
  'Temple-122', '静安别院 122', 'shrine', '静安别院 122（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0122',
  3, 81, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.411926, 31.160566), 4326),
  'Temple-123', '基督教堂 123', 'shrine', '基督教堂 123（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0123',
  3, 51, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.385166, 31.221109), 4326),
  'Temple-124', '老城隍庙 124', 'shrine', '老城隍庙 124（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0124',
  3, 76, '{}'::jsonb, 30, 'active', false,
  false, NULL, 3, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.562199, 31.173305), 4326),
  'Temple-125', '基督教堂 125', 'shrine', '基督教堂 125（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0125',
  4, 66, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.471309, 31.312064), 4326),
  'Temple-126', '基督教堂 126', 'shrine', '基督教堂 126（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0126',
  4, 66, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.377387, 31.219373), 4326),
  'Temple-127', '静安别院 127', 'shrine', '静安别院 127（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0127',
  4, 86, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.427044, 31.315844), 4326),
  'Temple-128', '基督教堂 128', 'shrine', '基督教堂 128（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0128',
  5, 79, '{}'::jsonb, 30, 'active', false,
  false, NULL, 35, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.505514, 31.294426), 4326),
  'Temple-129', '老城隍庙 129', 'shrine', '老城隍庙 129（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0129',
  3, 90, '{}'::jsonb, 30, 'active', false,
  false, NULL, 37, 0.62)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.481669, 31.183262), 4326),
  'Temple-130', '基督教堂 130', 'shrine', '基督教堂 130（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0130',
  4, 55, '{}'::jsonb, 30, 'active', false,
  false, NULL, 10, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.526907, 31.316833), 4326),
  'Museum-131', '弄堂记忆馆 131', 'museum', '弄堂记忆馆 131（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0131',
  3, 66, '{}'::jsonb, 30, 'active', false,
  false, NULL, 11, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.409803, 31.225627), 4326),
  'Museum-132', '消防博物馆 132', 'museum', '消防博物馆 132（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0132',
  4, 87, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.568589, 31.281644), 4326),
  'Museum-133', '纺织博物馆 133', 'museum', '纺织博物馆 133（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0133',
  4, 73, '{}'::jsonb, 30, 'active', false,
  false, NULL, 8, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.559837, 31.165329), 4326),
  'Museum-134', '纺织博物馆 134', 'museum', '纺织博物馆 134（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0134',
  3, 76, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476376, 31.258590), 4326),
  'Museum-135', '纺织博物馆 135', 'museum', '纺织博物馆 135（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0135',
  3, 60, '{}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.435492, 31.307658), 4326),
  'Museum-136', '弄堂记忆馆 136', 'museum', '弄堂记忆馆 136（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0136',
  3, 93, '{}'::jsonb, 30, 'active', false,
  false, NULL, 36, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.384650, 31.220524), 4326),
  'Museum-137', '唱片博物馆 137', 'museum', '唱片博物馆 137（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0137',
  3, 77, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.437204, 31.297638), 4326),
  'Museum-138', '纺织博物馆 138', 'museum', '纺织博物馆 138（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0138',
  2, 77, '{}'::jsonb, 30, 'active', false,
  false, NULL, 19, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.566483, 31.288761), 4326),
  'Museum-139', '纺织博物馆 139', 'museum', '纺织博物馆 139（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0139',
  4, 90, '{}'::jsonb, 30, 'active', false,
  false, NULL, 80, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.417092, 31.270411), 4326),
  'Museum-140', '弄堂记忆馆 140', 'museum', '弄堂记忆馆 140（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0140',
  4, 71, '{}'::jsonb, 30, 'active', false,
  false, NULL, 15, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.427438, 31.298809), 4326),
  'Museum-141', '邮票博物馆 141', 'museum', '邮票博物馆 141（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0141',
  3, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.532428, 31.163930), 4326),
  'Museum-142', '消防博物馆 142', 'museum', '消防博物馆 142（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0142',
  3, 91, '{}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.380683, 31.185497), 4326),
  'Museum-143', '纺织博物馆 143', 'museum', '纺织博物馆 143（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0143',
  3, 62, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.403249, 31.160423), 4326),
  'Museum-144', '纺织博物馆 144', 'museum', '纺织博物馆 144（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0144',
  4, 69, '{}'::jsonb, 30, 'active', false,
  false, NULL, 32, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.399179, 31.232588), 4326),
  'Museum-145', '邮票博物馆 145', 'museum', '邮票博物馆 145（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0145',
  3, 74, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.472775, 31.166142), 4326),
  'Museum-146', '邮票博物馆 146', 'museum', '邮票博物馆 146（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0146',
  3, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 40, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.561819, 31.209314), 4326),
  'Museum-147', '纺织博物馆 147', 'museum', '纺织博物馆 147（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0147',
  3, 60, '{}'::jsonb, 30, 'active', false,
  false, NULL, 1, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.545318, 31.180231), 4326),
  'Museum-148', '唱片博物馆 148', 'museum', '唱片博物馆 148（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0148',
  3, 65, '{}'::jsonb, 30, 'active', false,
  false, NULL, 36, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.455792, 31.227579), 4326),
  'Museum-149', '弄堂记忆馆 149', 'museum', '弄堂记忆馆 149（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0149',
  4, 59, '{}'::jsonb, 30, 'active', false,
  false, NULL, 21, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.435040, 31.149675), 4326),
  'Museum-150', '唱片博物馆 150', 'museum', '唱片博物馆 150（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0150',
  3, 56, '{}'::jsonb, 30, 'active', false,
  false, NULL, 14, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.519206, 31.156308), 4326),
  'Museum-151', '纺织博物馆 151', 'museum', '纺织博物馆 151（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0151',
  5, 79, '{}'::jsonb, 30, 'active', false,
  false, NULL, 25, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.387575, 31.174432), 4326),
  'Museum-152', '邮票博物馆 152', 'museum', '邮票博物馆 152（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0152',
  3, 59, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.466846, 31.294010), 4326),
  'Museum-153', '消防博物馆 153', 'museum', '消防博物馆 153（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0153',
  3, 84, '{}'::jsonb, 30, 'active', false,
  false, NULL, 13, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.527351, 31.282964), 4326),
  'Museum-154', '纺织博物馆 154', 'museum', '纺织博物馆 154（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0154',
  4, 94, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.518855, 31.301494), 4326),
  'Museum-155', '纺织博物馆 155', 'museum', '纺织博物馆 155（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0155',
  3, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 28, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.442300, 31.158538), 4326),
  'Museum-156', '消防博物馆 156', 'museum', '消防博物馆 156（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0156',
  3, 69, '{}'::jsonb, 30, 'active', false,
  false, NULL, 11, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.401849, 31.220544), 4326),
  'Museum-157', '唱片博物馆 157', 'museum', '唱片博物馆 157（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0157',
  4, 85, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.528934, 31.216088), 4326),
  'Museum-158', '唱片博物馆 158', 'museum', '唱片博物馆 158（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0158',
  3, 89, '{}'::jsonb, 30, 'active', false,
  false, NULL, 11, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.489617, 31.273235), 4326),
  'Museum-159', '弄堂记忆馆 159', 'museum', '弄堂记忆馆 159（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0159',
  3, 94, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.441190, 31.219919), 4326),
  'Museum-160', '纺织博物馆 160', 'museum', '纺织博物馆 160（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0160',
  4, 58, '{}'::jsonb, 30, 'active', false,
  false, NULL, 37, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.542902, 31.191860), 4326),
  'Museum-161', '纺织博物馆 161', 'museum', '纺织博物馆 161（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0161',
  5, 67, '{}'::jsonb, 30, 'active', false,
  false, NULL, 5, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.400810, 31.207013), 4326),
  'Museum-162', '唱片博物馆 162', 'museum', '唱片博物馆 162（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0162',
  3, 84, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.430175, 31.292070), 4326),
  'Museum-163', '邮票博物馆 163', 'museum', '邮票博物馆 163（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0163',
  4, 71, '{}'::jsonb, 30, 'active', false,
  false, NULL, 15, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.505112, 31.273258), 4326),
  'Museum-164', '唱片博物馆 164', 'museum', '唱片博物馆 164（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0164',
  3, 90, '{}'::jsonb, 30, 'active', false,
  false, NULL, 23, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.542666, 31.298977), 4326),
  'Museum-165', '消防博物馆 165', 'museum', '消防博物馆 165（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0165',
  4, 56, '{}'::jsonb, 30, 'active', false,
  false, NULL, 20, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.559310, 31.206442), 4326),
  'Museum-166', '纺织博物馆 166', 'museum', '纺织博物馆 166（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0166',
  3, 64, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.585999, 31.215507), 4326),
  'Museum-167', '弄堂记忆馆 167', 'museum', '弄堂记忆馆 167（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0167',
  2, 66, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.529815, 31.312389), 4326),
  'Museum-168', '唱片博物馆 168', 'museum', '唱片博物馆 168（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0168',
  3, 75, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.370612, 31.189171), 4326),
  'Museum-169', '纺织博物馆 169', 'museum', '纺织博物馆 169（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0169',
  3, 73, '{}'::jsonb, 30, 'active', false,
  false, NULL, 4, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.489091, 31.284868), 4326),
  'Museum-170', '消防博物馆 170', 'museum', '消防博物馆 170（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0170',
  3, 66, '{}'::jsonb, 30, 'active', false,
  false, NULL, 25, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.450096, 31.207354), 4326),
  'Museum-171', '纺织博物馆 171', 'museum', '纺织博物馆 171（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0171',
  3, 83, '{}'::jsonb, 30, 'active', false,
  false, NULL, 15, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.394448, 31.204116), 4326),
  'Museum-172', '纺织博物馆 172', 'museum', '纺织博物馆 172（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0172',
  2, 79, '{}'::jsonb, 30, 'active', false,
  false, NULL, 5, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.460432, 31.325875), 4326),
  'Museum-173', '弄堂记忆馆 173', 'museum', '弄堂记忆馆 173（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0173',
  3, 73, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.499336, 31.161391), 4326),
  'Museum-174', '纺织博物馆 174', 'museum', '纺织博物馆 174（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0174',
  3, 61, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476003, 31.230946), 4326),
  'Museum-175', '邮票博物馆 175', 'museum', '邮票博物馆 175（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0175',
  3, 92, '{}'::jsonb, 30, 'active', false,
  false, NULL, 31, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.361215, 31.238348), 4326),
  'Monument-176', '百年校址碑塔 176', 'monument', '百年校址碑塔 176（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0176',
  3, 61, '{}'::jsonb, 30, 'active', false,
  false, NULL, 14, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.521137, 31.307649), 4326),
  'Monument-177', '抗战纪念墙 177', 'monument', '抗战纪念墙 177（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0177',
  3, 72, '{}'::jsonb, 30, 'active', false,
  false, NULL, 18, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.470196, 31.285292), 4326),
  'Monument-178', '工人纪念碑 178', 'monument', '工人纪念碑 178（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0178',
  3, 68, '{}'::jsonb, 30, 'active', false,
  false, NULL, 6, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476429, 31.234322), 4326),
  'Monument-179', '艺术家雕像 179', 'monument', '艺术家雕像 179（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0179',
  3, 60, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.443553, 31.207438), 4326),
  'Monument-180', '工人纪念碑 180', 'monument', '工人纪念碑 180（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0180',
  4, 60, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.426758, 31.288828), 4326),
  'Monument-181', '艺术家雕像 181', 'monument', '艺术家雕像 181（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0181',
  4, 69, '{}'::jsonb, 30, 'active', false,
  false, NULL, 22, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.429982, 31.232143), 4326),
  'Monument-182', '工人纪念碑 182', 'monument', '工人纪念碑 182（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0182',
  3, 71, '{}'::jsonb, 30, 'active', false,
  false, NULL, 113, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.449994, 31.261381), 4326),
  'Monument-183', '艺术家雕像 183', 'monument', '艺术家雕像 183（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0183',
  4, 73, '{}'::jsonb, 30, 'active', false,
  false, NULL, 34, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.372768, 31.189033), 4326),
  'Monument-184', '工人纪念碑 184', 'monument', '工人纪念碑 184（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0184',
  3, 81, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476083, 31.190692), 4326),
  'Monument-185', '工人纪念碑 185', 'monument', '工人纪念碑 185（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0185',
  3, 80, '{}'::jsonb, 30, 'active', false,
  false, NULL, 4, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.458484, 31.168660), 4326),
  'Monument-186', '艺术家雕像 186', 'monument', '艺术家雕像 186（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0186',
  3, 89, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.527056, 31.162425), 4326),
  'Monument-187', '百年校址碑塔 187', 'monument', '百年校址碑塔 187（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0187',
  4, 83, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.505818, 31.322032), 4326),
  'Monument-188', '城市纪念雕塑 188', 'monument', '城市纪念雕塑 188（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0188',
  4, 80, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.437209, 31.238557), 4326),
  'Monument-189', '百年校址碑塔 189', 'monument', '百年校址碑塔 189（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0189',
  3, 94, '{}'::jsonb, 30, 'active', false,
  false, NULL, 28, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.370682, 31.219593), 4326),
  'Monument-190', '工人纪念碑 190', 'monument', '工人纪念碑 190（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0190',
  3, 87, '{}'::jsonb, 30, 'active', false,
  false, NULL, 26, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.490490, 31.245332), 4326),
  'Monument-191', '抗战纪念墙 191', 'monument', '抗战纪念墙 191（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0191',
  3, 65, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.438937, 31.174095), 4326),
  'Monument-192', '百年校址碑塔 192', 'monument', '百年校址碑塔 192（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0192',
  4, 58, '{}'::jsonb, 30, 'active', false,
  false, NULL, 27, 0.98)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.382894, 31.245852), 4326),
  'Monument-193', '艺术家雕像 193', 'monument', '艺术家雕像 193（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0193',
  4, 85, '{}'::jsonb, 30, 'active', false,
  false, NULL, 14, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.458933, 31.142272), 4326),
  'Monument-194', '艺术家雕像 194', 'monument', '艺术家雕像 194（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0194',
  3, 72, '{}'::jsonb, 30, 'active', false,
  false, NULL, 11, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.413606, 31.279336), 4326),
  'Monument-195', '抗战纪念墙 195', 'monument', '抗战纪念墙 195（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0195',
  4, 90, '{}'::jsonb, 30, 'active', false,
  false, NULL, 32, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.447314, 31.270124), 4326),
  'Monument-196', '抗战纪念墙 196', 'monument', '抗战纪念墙 196（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0196',
  3, 56, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.479447, 31.217491), 4326),
  'Monument-197', '城市纪念雕塑 197', 'monument', '城市纪念雕塑 197（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0197',
  4, 88, '{}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.461957, 31.325820), 4326),
  'Monument-198', '抗战纪念墙 198', 'monument', '抗战纪念墙 198（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0198',
  3, 86, '{}'::jsonb, 30, 'active', false,
  false, NULL, 20, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.521304, 31.286954), 4326),
  'Monument-199', '城市纪念雕塑 199', 'monument', '城市纪念雕塑 199（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0199',
  4, 64, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.410683, 31.190428), 4326),
  'Monument-200', '城市纪念雕塑 200', 'monument', '城市纪念雕塑 200（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0200',
  3, 61, '{}'::jsonb, 30, 'active', false,
  false, NULL, 108, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.491348, 31.271004), 4326),
  'Monument-201', '城市纪念雕塑 201', 'monument', '城市纪念雕塑 201（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0201',
  3, 83, '{}'::jsonb, 30, 'active', false,
  false, NULL, 89, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.544215, 31.249848), 4326),
  'Monument-202', '工人纪念碑 202', 'monument', '工人纪念碑 202（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0202',
  3, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 2, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.439211, 31.255603), 4326),
  'Monument-203', '城市纪念雕塑 203', 'monument', '城市纪念雕塑 203（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0203',
  4, 59, '{}'::jsonb, 30, 'active', false,
  false, NULL, 35, 0.62)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.482170, 31.137615), 4326),
  'Monument-204', '城市纪念雕塑 204', 'monument', '城市纪念雕塑 204（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0204',
  4, 93, '{}'::jsonb, 30, 'active', false,
  false, NULL, 17, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.494201, 31.290301), 4326),
  'Monument-205', '城市纪念雕塑 205', 'monument', '城市纪念雕塑 205（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0205',
  4, 79, '{}'::jsonb, 30, 'active', false,
  false, NULL, 23, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.551964, 31.215270), 4326),
  'Monument-206', '城市纪念雕塑 206', 'monument', '城市纪念雕塑 206（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0206',
  3, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.534092, 31.230591), 4326),
  'Monument-207', '工人纪念碑 207', 'monument', '工人纪念碑 207（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0207',
  5, 87, '{}'::jsonb, 30, 'active', false,
  false, NULL, 27, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.418954, 31.219324), 4326),
  'Monument-208', '城市纪念雕塑 208', 'monument', '城市纪念雕塑 208（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0208',
  4, 87, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.574054, 31.199334), 4326),
  'Monument-209', '艺术家雕像 209', 'monument', '艺术家雕像 209（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0209',
  3, 56, '{}'::jsonb, 30, 'active', false,
  false, NULL, 39, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.550450, 31.251919), 4326),
  'Monument-210', '百年校址碑塔 210', 'monument', '百年校址碑塔 210（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0210',
  4, 64, '{}'::jsonb, 30, 'active', false,
  false, NULL, 3, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.509564, 31.286238), 4326),
  'Monument-211', '抗战纪念墙 211', 'monument', '抗战纪念墙 211（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0211',
  3, 67, '{}'::jsonb, 30, 'active', false,
  false, NULL, 114, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.532544, 31.235330), 4326),
  'Monument-212', '工人纪念碑 212', 'monument', '工人纪念碑 212（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0212',
  4, 84, '{}'::jsonb, 30, 'active', false,
  false, NULL, 37, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.521156, 31.163076), 4326),
  'Monument-213', '抗战纪念墙 213', 'monument', '抗战纪念墙 213（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0213',
  4, 78, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.398122, 31.289962), 4326),
  'Monument-214', '工人纪念碑 214', 'monument', '工人纪念碑 214（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0214',
  4, 84, '{}'::jsonb, 30, 'active', false,
  false, NULL, 39, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.490285, 31.241577), 4326),
  'Monument-215', '工人纪念碑 215', 'monument', '工人纪念碑 215（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0215',
  4, 71, '{}'::jsonb, 30, 'active', false,
  false, NULL, 13, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.412822, 31.260683), 4326),
  'Monument-216', '百年校址碑塔 216', 'monument', '百年校址碑塔 216（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0216',
  4, 79, '{}'::jsonb, 30, 'active', false,
  false, NULL, 10, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.434388, 31.266610), 4326),
  'Monument-217', '工人纪念碑 217', 'monument', '工人纪念碑 217（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0217',
  3, 58, '{}'::jsonb, 30, 'active', false,
  false, NULL, 40, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.385418, 31.269845), 4326),
  'Monument-218', '艺术家雕像 218', 'monument', '艺术家雕像 218（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0218',
  4, 88, '{}'::jsonb, 30, 'active', false,
  false, NULL, 28, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.453111, 31.173438), 4326),
  'Monument-219', '百年校址碑塔 219', 'monument', '百年校址碑塔 219（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0219',
  4, 62, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.369849, 31.215051), 4326),
  'Monument-220', '工人纪念碑 220', 'monument', '工人纪念碑 220（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0220',
  4, 61, '{}'::jsonb, 30, 'active', false,
  false, NULL, 37, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.462811, 31.137644), 4326),
  'Stone-221', '老码头界碑 221', 'landmark_stone', '老码头界碑 221（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0221',
  3, 84, '{}'::jsonb, 20, 'active', false,
  false, NULL, 15, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.549708, 31.282405), 4326),
  'Stone-222', '商号旧址碑 222', 'landmark_stone', '商号旧址碑 222（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0222',
  4, 66, '{}'::jsonb, 20, 'active', false,
  false, NULL, 9, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.368437, 31.190507), 4326),
  'Stone-223', '里坊铭牌 223', 'landmark_stone', '里坊铭牌 223（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0223',
  3, 62, '{}'::jsonb, 20, 'active', false,
  false, NULL, 0, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.564204, 31.232631), 4326),
  'Stone-224', '古城墙残碑 224', 'landmark_stone', '古城墙残碑 224（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0224',
  3, 68, '{}'::jsonb, 20, 'active', false,
  false, NULL, 21, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.514561, 31.317070), 4326),
  'Stone-225', '老码头界碑 225', 'landmark_stone', '老码头界碑 225（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0225',
  3, 89, '{}'::jsonb, 20, 'active', false,
  false, NULL, 32, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.511738, 31.208445), 4326),
  'Stone-226', '里坊铭牌 226', 'landmark_stone', '里坊铭牌 226（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0226',
  3, 69, '{}'::jsonb, 20, 'active', false,
  false, NULL, 2, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.455846, 31.151985), 4326),
  'Stone-227', '古城墙残碑 227', 'landmark_stone', '古城墙残碑 227（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0227',
  3, 69, '{}'::jsonb, 20, 'active', false,
  false, NULL, 0, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.463150, 31.323716), 4326),
  'Stone-228', '桥梁奠基石 228', 'landmark_stone', '桥梁奠基石 228（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0228',
  4, 83, '{}'::jsonb, 20, 'active', false,
  false, NULL, 1, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.552828, 31.160104), 4326),
  'Stone-229', '商号旧址碑 229', 'landmark_stone', '商号旧址碑 229（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0229',
  4, 74, '{}'::jsonb, 20, 'active', false,
  false, NULL, 9, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.488408, 31.316966), 4326),
  'Stone-230', '古城墙残碑 230', 'landmark_stone', '古城墙残碑 230（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0230',
  4, 86, '{}'::jsonb, 20, 'active', false,
  false, NULL, 7, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.519534, 31.311946), 4326),
  'Stone-231', '古城墙残碑 231', 'landmark_stone', '古城墙残碑 231（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0231',
  3, 55, '{}'::jsonb, 20, 'active', false,
  false, NULL, 16, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.532699, 31.159840), 4326),
  'Stone-232', '桥梁奠基石 232', 'landmark_stone', '桥梁奠基石 232（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0232',
  3, 62, '{}'::jsonb, 20, 'active', false,
  false, NULL, 10, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.443298, 31.304753), 4326),
  'Stone-233', '老码头界碑 233', 'landmark_stone', '老码头界碑 233（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0233',
  4, 58, '{}'::jsonb, 20, 'active', false,
  false, NULL, 101, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.438305, 31.293731), 4326),
  'Stone-234', '商号旧址碑 234', 'landmark_stone', '商号旧址碑 234（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0234',
  4, 62, '{}'::jsonb, 20, 'active', false,
  false, NULL, 28, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.475308, 31.300980), 4326),
  'Stone-235', '里坊铭牌 235', 'landmark_stone', '里坊铭牌 235（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0235',
  4, 73, '{}'::jsonb, 20, 'active', false,
  false, NULL, 20, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.508420, 31.253895), 4326),
  'Stone-236', '老码头界碑 236', 'landmark_stone', '老码头界碑 236（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0236',
  3, 74, '{}'::jsonb, 20, 'active', false,
  false, NULL, 97, 0.67)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.466088, 31.265810), 4326),
  'Stone-237', '老码头界碑 237', 'landmark_stone', '老码头界碑 237（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0237',
  3, 65, '{}'::jsonb, 20, 'active', false,
  false, NULL, 3, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.371211, 31.257188), 4326),
  'Stone-238', '桥梁奠基石 238', 'landmark_stone', '桥梁奠基石 238（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0238',
  3, 87, '{}'::jsonb, 20, 'active', false,
  false, NULL, 66, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.505172, 31.277917), 4326),
  'Stone-239', '桥梁奠基石 239', 'landmark_stone', '桥梁奠基石 239（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0239',
  3, 51, '{}'::jsonb, 20, 'active', false,
  false, NULL, 26, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.363105, 31.258377), 4326),
  'Stone-240', '里坊铭牌 240', 'landmark_stone', '里坊铭牌 240（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0240',
  4, 69, '{}'::jsonb, 20, 'active', false,
  false, NULL, 0, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.463147, 31.150280), 4326),
  'Stone-241', '古城墙残碑 241', 'landmark_stone', '古城墙残碑 241（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0241',
  3, 80, '{}'::jsonb, 20, 'active', false,
  false, NULL, 17, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.502224, 31.283477), 4326),
  'Stone-242', '商号旧址碑 242', 'landmark_stone', '商号旧址碑 242（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0242',
  3, 73, '{}'::jsonb, 20, 'active', false,
  false, NULL, 35, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.516175, 31.309096), 4326),
  'Stone-243', '商号旧址碑 243', 'landmark_stone', '商号旧址碑 243（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0243',
  3, 81, '{}'::jsonb, 20, 'active', false,
  false, NULL, 0, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.480748, 31.239973), 4326),
  'Stone-244', '古城墙残碑 244', 'landmark_stone', '古城墙残碑 244（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0244',
  3, 77, '{}'::jsonb, 20, 'active', false,
  false, NULL, 27, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.402389, 31.163550), 4326),
  'Stone-245', '桥梁奠基石 245', 'landmark_stone', '桥梁奠基石 245（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0245',
  3, 78, '{}'::jsonb, 20, 'active', false,
  false, NULL, 14, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.376213, 31.250536), 4326),
  'Stone-246', '古城墙残碑 246', 'landmark_stone', '古城墙残碑 246（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0246',
  4, 87, '{}'::jsonb, 20, 'active', false,
  false, NULL, 40, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.552915, 31.258568), 4326),
  'Stone-247', '老码头界碑 247', 'landmark_stone', '老码头界碑 247（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0247',
  3, 74, '{}'::jsonb, 20, 'active', false,
  false, NULL, 11, 0.98)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.488685, 31.320331), 4326),
  'Stone-248', '老码头界碑 248', 'landmark_stone', '老码头界碑 248（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0248',
  4, 62, '{}'::jsonb, 20, 'active', false,
  false, NULL, 16, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.438018, 31.301206), 4326),
  'Stone-249', '古城墙残碑 249', 'landmark_stone', '古城墙残碑 249（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0249',
  3, 87, '{}'::jsonb, 20, 'active', false,
  false, NULL, 65, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.412425, 31.257709), 4326),
  'Stone-250', '古城墙残碑 250', 'landmark_stone', '古城墙残碑 250（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0250',
  4, 90, '{}'::jsonb, 20, 'active', false,
  false, NULL, 0, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.452217, 31.264950), 4326),
  'PublicFacility-251', '邻里中心 251', 'public_facility', '邻里中心 251（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0251',
  3, 74, '{}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.491549, 31.237050), 4326),
  'PublicFacility-252', '区图书馆 252', 'public_facility', '区图书馆 252（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0252',
  4, 73, '{}'::jsonb, 30, 'active', false,
  false, NULL, 15, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.458243, 31.280444), 4326),
  'PublicFacility-253', '市民健身中心 253', 'public_facility', '市民健身中心 253（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0253',
  3, 65, '{}'::jsonb, 30, 'active', true,
  false, NULL, 120, 0.67)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.385829, 31.200799), 4326),
  'PublicFacility-254', '区图书馆 254', 'public_facility', '区图书馆 254（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0254',
  4, 92, '{}'::jsonb, 30, 'active', false,
  false, NULL, 9, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.379173, 31.181200), 4326),
  'PublicFacility-255', '区图书馆 255', 'public_facility', '区图书馆 255（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0255',
  4, 64, '{}'::jsonb, 30, 'active', false,
  false, NULL, 33, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.565851, 31.246942), 4326),
  'PublicFacility-256', '市民健身中心 256', 'public_facility', '市民健身中心 256（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0256',
  3, 74, '{}'::jsonb, 30, 'active', true,
  false, NULL, 16, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.503328, 31.175609), 4326),
  'PublicFacility-257', '社区文化中心 257', 'public_facility', '社区文化中心 257（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0257',
  4, 62, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.425162, 31.308928), 4326),
  'PublicFacility-258', '科普活动站 258', 'public_facility', '科普活动站 258（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0258',
  3, 93, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.446408, 31.221013), 4326),
  'PublicFacility-259', '社区文化中心 259', 'public_facility', '社区文化中心 259（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0259',
  4, 98, '{}'::jsonb, 30, 'active', false,
  false, NULL, 40, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.418171, 31.216652), 4326),
  'PublicFacility-260', '区图书馆 260', 'public_facility', '区图书馆 260（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0260',
  3, 80, '{}'::jsonb, 30, 'active', false,
  false, NULL, 2, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.511349, 31.242532), 4326),
  'PublicFacility-261', '邻里中心 261', 'public_facility', '邻里中心 261（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0261',
  4, 74, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.567667, 31.280572), 4326),
  'PublicFacility-262', '科普活动站 262', 'public_facility', '科普活动站 262（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0262',
  3, 94, '{}'::jsonb, 30, 'active', true,
  false, NULL, 5, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.575663, 31.208412), 4326),
  'PublicFacility-263', '邻里中心 263', 'public_facility', '邻里中心 263（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0263',
  4, 74, '{}'::jsonb, 30, 'active', false,
  false, NULL, 23, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.398427, 31.164266), 4326),
  'PublicFacility-264', '市民健身中心 264', 'public_facility', '市民健身中心 264（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0264',
  4, 61, '{}'::jsonb, 30, 'active', false,
  false, NULL, 27, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.420699, 31.222690), 4326),
  'PublicFacility-265', '区图书馆 265', 'public_facility', '区图书馆 265（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0265',
  3, 69, '{}'::jsonb, 30, 'active', false,
  false, NULL, 19, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.521851, 31.169904), 4326),
  'PublicFacility-266', '社区文化中心 266', 'public_facility', '社区文化中心 266（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0266',
  4, 86, '{}'::jsonb, 30, 'active', true,
  false, NULL, 21, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.467137, 31.237826), 4326),
  'PublicFacility-267', '区图书馆 267', 'public_facility', '区图书馆 267（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0267',
  3, 68, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.410927, 31.256803), 4326),
  'PublicFacility-268', '区图书馆 268', 'public_facility', '区图书馆 268（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0268',
  4, 87, '{}'::jsonb, 30, 'active', true,
  false, NULL, 34, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.552868, 31.295591), 4326),
  'PublicFacility-269', '市民健身中心 269', 'public_facility', '市民健身中心 269（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0269',
  4, 89, '{}'::jsonb, 30, 'active', false,
  false, NULL, 1, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.563543, 31.264511), 4326),
  'PublicFacility-270', '邻里中心 270', 'public_facility', '邻里中心 270（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0270',
  4, 71, '{}'::jsonb, 30, 'active', false,
  false, NULL, 113, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.502242, 31.269819), 4326),
  'PublicFacility-271', '社区文化中心 271', 'public_facility', '社区文化中心 271（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0271',
  3, 98, '{}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.458174, 31.273578), 4326),
  'PublicFacility-272', '区图书馆 272', 'public_facility', '区图书馆 272（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0272',
  4, 63, '{}'::jsonb, 30, 'active', false,
  false, NULL, 36, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.510276, 31.211748), 4326),
  'PublicFacility-273', '市民健身中心 273', 'public_facility', '市民健身中心 273（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0273',
  3, 68, '{}'::jsonb, 30, 'active', false,
  false, NULL, 36, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.411215, 31.194858), 4326),
  'PublicFacility-274', '社区文化中心 274', 'public_facility', '社区文化中心 274（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0274',
  3, 97, '{}'::jsonb, 30, 'active', true,
  false, NULL, 38, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.481823, 31.277178), 4326),
  'PublicFacility-275', '邻里中心 275', 'public_facility', '邻里中心 275（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0275',
  4, 66, '{}'::jsonb, 30, 'active', true,
  false, NULL, 62, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.468843, 31.162718), 4326),
  'PublicFacility-276', '市民健身中心 276', 'public_facility', '市民健身中心 276（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0276',
  3, 82, '{}'::jsonb, 30, 'active', true,
  false, NULL, 7, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.392678, 31.252614), 4326),
  'PublicFacility-277', '社区文化中心 277', 'public_facility', '社区文化中心 277（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0277',
  4, 86, '{}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.567988, 31.282457), 4326),
  'PublicFacility-278', '科普活动站 278', 'public_facility', '科普活动站 278（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0278',
  4, 98, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.438992, 31.163428), 4326),
  'PublicFacility-279', '市民健身中心 279', 'public_facility', '市民健身中心 279（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0279',
  5, 84, '{}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.431179, 31.167933), 4326),
  'PublicFacility-280', '区图书馆 280', 'public_facility', '区图书馆 280（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0280',
  4, 98, '{}'::jsonb, 30, 'active', false,
  false, NULL, 23, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.497554, 31.198115), 4326),
  'PublicFacility-281', '社区文化中心 281', 'public_facility', '社区文化中心 281（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0281',
  3, 67, '{}'::jsonb, 30, 'active', true,
  false, NULL, 25, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.521336, 31.266748), 4326),
  'PublicFacility-282', '科普活动站 282', 'public_facility', '科普活动站 282（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0282',
  4, 98, '{}'::jsonb, 30, 'active', true,
  false, NULL, 39, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.460020, 31.237415), 4326),
  'PublicFacility-283', '区图书馆 283', 'public_facility', '区图书馆 283（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0283',
  3, 92, '{}'::jsonb, 30, 'active', false,
  false, NULL, 30, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.479363, 31.223512), 4326),
  'PublicFacility-284', '科普活动站 284', 'public_facility', '科普活动站 284（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0284',
  4, 61, '{}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.426748, 31.217763), 4326),
  'PublicFacility-285', '邻里中心 285', 'public_facility', '邻里中心 285（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0285',
  4, 86, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.472026, 31.219065), 4326),
  'PublicFacility-286', '市民健身中心 286', 'public_facility', '市民健身中心 286（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0286',
  5, 87, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.405697, 31.185016), 4326),
  'PublicFacility-287', '科普活动站 287', 'public_facility', '科普活动站 287（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0287',
  4, 83, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476142, 31.277671), 4326),
  'PublicFacility-288', '市民健身中心 288', 'public_facility', '市民健身中心 288（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0288',
  4, 65, '{}'::jsonb, 30, 'active', false,
  false, NULL, 27, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.425891, 31.182037), 4326),
  'PublicFacility-289', '市民健身中心 289', 'public_facility', '市民健身中心 289（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0289',
  3, 85, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.479458, 31.193838), 4326),
  'PublicFacility-290', '市民健身中心 290', 'public_facility', '市民健身中心 290（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0290',
  3, 69, '{}'::jsonb, 30, 'active', false,
  false, NULL, 5, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.568453, 31.255242), 4326),
  'PublicFacility-291', '市民健身中心 291', 'public_facility', '市民健身中心 291（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0291',
  3, 85, '{}'::jsonb, 30, 'active', false,
  false, NULL, 24, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.576250, 31.253902), 4326),
  'PublicFacility-292', '市民健身中心 292', 'public_facility', '市民健身中心 292（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0292',
  4, 94, '{}'::jsonb, 30, 'active', true,
  false, NULL, 25, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.551876, 31.189348), 4326),
  'PublicFacility-293', '区图书馆 293', 'public_facility', '区图书馆 293（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0293',
  4, 76, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.384494, 31.264502), 4326),
  'PublicFacility-294', '区图书馆 294', 'public_facility', '区图书馆 294（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0294',
  4, 78, '{}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.378700, 31.235496), 4326),
  'PublicFacility-295', '邻里中心 295', 'public_facility', '邻里中心 295（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0295',
  3, 63, '{}'::jsonb, 30, 'active', true,
  false, NULL, 12, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.427073, 31.214473), 4326),
  'PublicFacility-296', '区图书馆 296', 'public_facility', '区图书馆 296（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0296',
  4, 78, '{}'::jsonb, 30, 'active', false,
  false, NULL, 21, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.395832, 31.202691), 4326),
  'PublicFacility-297', '区图书馆 297', 'public_facility', '区图书馆 297（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0297',
  3, 84, '{}'::jsonb, 30, 'active', false,
  false, NULL, 23, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.492294, 31.295973), 4326),
  'PublicFacility-298', '区图书馆 298', 'public_facility', '区图书馆 298（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0298',
  3, 92, '{}'::jsonb, 30, 'active', true,
  false, NULL, 32, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.447360, 31.250716), 4326),
  'PublicFacility-299', '市民健身中心 299', 'public_facility', '市民健身中心 299（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0299',
  3, 91, '{}'::jsonb, 30, 'active', true,
  false, NULL, 3, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.532886, 31.188661), 4326),
  'PublicFacility-300', '邻里中心 300', 'public_facility', '邻里中心 300（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0300',
  3, 67, '{}'::jsonb, 30, 'active', false,
  false, NULL, 40, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.482255, 31.263307), 4326),
  'Plaza-301', '下沉式广场 301', 'plaza', '下沉式广场 301（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0301',
  3, 78, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.495447, 31.164223), 4326),
  'Plaza-302', '下沉式广场 302', 'plaza', '下沉式广场 302（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0302',
  5, 82, '{}'::jsonb, 50, 'active', true,
  false, NULL, 5, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.473299, 31.320764), 4326),
  'Plaza-303', '喷泉广场 303', 'plaza', '喷泉广场 303（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0303',
  3, 96, '{}'::jsonb, 50, 'active', true,
  false, NULL, 37, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.470812, 31.318443), 4326),
  'Plaza-304', '下沉式广场 304', 'plaza', '下沉式广场 304（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0304',
  3, 78, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.586754, 31.215442), 4326),
  'Plaza-305', '音乐广场 305', 'plaza', '音乐广场 305（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0305',
  4, 83, '{}'::jsonb, 50, 'active', false,
  false, NULL, 0, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.551423, 31.158738), 4326),
  'Plaza-306', '站前广场 306', 'plaza', '站前广场 306（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0306',
  4, 82, '{}'::jsonb, 50, 'active', true,
  false, NULL, 5, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.481327, 31.244968), 4326),
  'Plaza-307', '文化广场 307', 'plaza', '文化广场 307（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0307',
  4, 97, '{}'::jsonb, 50, 'active', true,
  false, NULL, 40, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.366196, 31.262439), 4326),
  'Plaza-308', '音乐广场 308', 'plaza', '音乐广场 308（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0308',
  4, 71, '{}'::jsonb, 50, 'active', true,
  false, NULL, 1, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.432957, 31.222901), 4326),
  'Plaza-309', '喷泉广场 309', 'plaza', '喷泉广场 309（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0309',
  3, 82, '{}'::jsonb, 50, 'active', true,
  false, NULL, 26, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.535495, 31.291138), 4326),
  'Plaza-310', '文化广场 310', 'plaza', '文化广场 310（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0310',
  3, 66, '{}'::jsonb, 50, 'active', true,
  false, NULL, 19, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.515370, 31.213832), 4326),
  'Plaza-311', '站前广场 311', 'plaza', '站前广场 311（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0311',
  3, 87, '{}'::jsonb, 50, 'active', false,
  false, NULL, 20, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.550343, 31.275480), 4326),
  'Plaza-312', '文化广场 312', 'plaza', '文化广场 312（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0312',
  4, 62, '{}'::jsonb, 50, 'active', true,
  false, NULL, 22, 0.62)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.548862, 31.272612), 4326),
  'Plaza-313', '喷泉广场 313', 'plaza', '喷泉广场 313（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0313',
  4, 96, '{}'::jsonb, 50, 'active', true,
  false, NULL, 38, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.427755, 31.274259), 4326),
  'Plaza-314', '文化广场 314', 'plaza', '文化广场 314（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0314',
  4, 79, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.502446, 31.308206), 4326),
  'Plaza-315', '文化广场 315', 'plaza', '文化广场 315（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0315',
  3, 64, '{}'::jsonb, 50, 'active', true,
  false, NULL, 24, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.416605, 31.271406), 4326),
  'Plaza-316', '文化广场 316', 'plaza', '文化广场 316（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0316',
  3, 78, '{}'::jsonb, 50, 'active', true,
  false, NULL, 20, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.422813, 31.212871), 4326),
  'Plaza-317', '音乐广场 317', 'plaza', '音乐广场 317（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0317',
  3, 93, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.393810, 31.265896), 4326),
  'Plaza-318', '喷泉广场 318', 'plaza', '喷泉广场 318（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0318',
  4, 98, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.466497, 31.229374), 4326),
  'Plaza-319', '站前广场 319', 'plaza', '站前广场 319（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0319',
  3, 77, '{}'::jsonb, 50, 'active', false,
  false, NULL, 39, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.463752, 31.203912), 4326),
  'Plaza-320', '喷泉广场 320', 'plaza', '喷泉广场 320（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0320',
  4, 82, '{}'::jsonb, 50, 'active', false,
  false, NULL, 0, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.517505, 31.302521), 4326),
  'Plaza-321', '站前广场 321', 'plaza', '站前广场 321（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0321',
  4, 88, '{}'::jsonb, 50, 'active', false,
  false, NULL, 10, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.463249, 31.162276), 4326),
  'Plaza-322', '文化广场 322', 'plaza', '文化广场 322（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0322',
  4, 77, '{}'::jsonb, 50, 'active', true,
  false, NULL, 10, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.394264, 31.235829), 4326),
  'Plaza-323', '喷泉广场 323', 'plaza', '喷泉广场 323（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0323',
  3, 77, '{}'::jsonb, 50, 'active', true,
  false, NULL, 3, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.460892, 31.236396), 4326),
  'Plaza-324', '站前广场 324', 'plaza', '站前广场 324（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0324',
  4, 89, '{}'::jsonb, 50, 'active', true,
  false, NULL, 17, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.450981, 31.277933), 4326),
  'Plaza-325', '下沉式广场 325', 'plaza', '下沉式广场 325（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0325',
  4, 90, '{}'::jsonb, 50, 'active', true,
  false, NULL, 26, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.518979, 31.263867), 4326),
  'Plaza-326', '站前广场 326', 'plaza', '站前广场 326（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0326',
  4, 76, '{}'::jsonb, 50, 'active', true,
  false, NULL, 16, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.386913, 31.266923), 4326),
  'Plaza-327', '站前广场 327', 'plaza', '站前广场 327（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0327',
  3, 81, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476604, 31.201436), 4326),
  'Plaza-328', '音乐广场 328', 'plaza', '音乐广场 328（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0328',
  3, 83, '{}'::jsonb, 50, 'active', false,
  false, NULL, 14, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.526784, 31.196948), 4326),
  'Plaza-329', '音乐广场 329', 'plaza', '音乐广场 329（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0329',
  4, 91, '{}'::jsonb, 50, 'active', false,
  false, NULL, 5, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.448798, 31.308439), 4326),
  'Plaza-330', '喷泉广场 330', 'plaza', '喷泉广场 330（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0330',
  3, 86, '{}'::jsonb, 50, 'active', true,
  false, NULL, 2, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.525710, 31.306571), 4326),
  'Plaza-331', '文化广场 331', 'plaza', '文化广场 331（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0331',
  4, 66, '{}'::jsonb, 50, 'active', false,
  false, NULL, 34, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.382529, 31.252880), 4326),
  'Plaza-332', '文化广场 332', 'plaza', '文化广场 332（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0332',
  4, 81, '{}'::jsonb, 50, 'active', false,
  false, NULL, 20, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.479468, 31.277062), 4326),
  'Plaza-333', '站前广场 333', 'plaza', '站前广场 333（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0333',
  3, 88, '{}'::jsonb, 50, 'active', true,
  false, NULL, 23, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.555064, 31.225867), 4326),
  'Plaza-334', '喷泉广场 334', 'plaza', '喷泉广场 334（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0334',
  3, 98, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.373066, 31.187441), 4326),
  'Plaza-335', '站前广场 335', 'plaza', '站前广场 335（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0335',
  3, 85, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.573526, 31.219683), 4326),
  'Plaza-336', '喷泉广场 336', 'plaza', '喷泉广场 336（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0336',
  4, 90, '{}'::jsonb, 50, 'active', true,
  false, NULL, 13, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.401950, 31.217139), 4326),
  'Plaza-337', '下沉式广场 337', 'plaza', '下沉式广场 337（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0337',
  3, 85, '{}'::jsonb, 50, 'active', true,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.509796, 31.218337), 4326),
  'Plaza-338', '音乐广场 338', 'plaza', '音乐广场 338（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0338',
  3, 92, '{}'::jsonb, 50, 'active', false,
  false, NULL, 29, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.371296, 31.210281), 4326),
  'Plaza-339', '喷泉广场 339', 'plaza', '喷泉广场 339（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0339',
  4, 93, '{}'::jsonb, 50, 'active', true,
  false, NULL, 14, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.545425, 31.274628), 4326),
  'Plaza-340', '喷泉广场 340', 'plaza', '喷泉广场 340（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0340',
  3, 79, '{}'::jsonb, 50, 'active', true,
  false, NULL, 35, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.404257, 31.288224), 4326),
  'Convenience-341', '夜宵街角点 341', 'convenience', '夜宵街角点 341（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0341',
  4, 90, '{}'::jsonb, 30, 'active', true,
  false, NULL, 25, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.442126, 31.323567), 4326),
  'Convenience-342', '地铁站口便利点 342', 'convenience', '地铁站口便利点 342（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0342',
  4, 79, '{}'::jsonb, 30, 'active', true,
  false, NULL, 9, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.402051, 31.259742), 4326),
  'Convenience-343', '夜宵街角点 343', 'convenience', '夜宵街角点 343（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0343',
  3, 68, '{}'::jsonb, 30, 'active', true,
  false, NULL, 15, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.488408, 31.175584), 4326),
  'Convenience-344', '社区超市点 344', 'convenience', '社区超市点 344（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0344',
  3, 90, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.511250, 31.163309), 4326),
  'Convenience-345', '社区超市点 345', 'convenience', '社区超市点 345（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0345',
  4, 85, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.549935, 31.250865), 4326),
  'Convenience-346', '社区超市点 346', 'convenience', '社区超市点 346（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0346',
  3, 89, '{}'::jsonb, 30, 'active', true,
  false, NULL, 20, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.455004, 31.171720), 4326),
  'Convenience-347', '夜宵街角点 347', 'convenience', '夜宵街角点 347（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0347',
  3, 66, '{}'::jsonb, 30, 'active', true,
  false, NULL, 29, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.543162, 31.188819), 4326),
  'Convenience-348', '地铁站口便利点 348', 'convenience', '地铁站口便利点 348（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0348',
  4, 88, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.381105, 31.207368), 4326),
  'Convenience-349', '夜宵街角点 349', 'convenience', '夜宵街角点 349（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0349',
  2, 76, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.474610, 31.193442), 4326),
  'Convenience-350', '便利店聚合点 350', 'convenience', '便利店聚合点 350（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0350',
  3, 63, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.482503, 31.307147), 4326),
  'Convenience-351', '社区超市点 351', 'convenience', '社区超市点 351（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0351',
  3, 70, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.453183, 31.134239), 4326),
  'Convenience-352', '地铁站口便利点 352', 'convenience', '地铁站口便利点 352（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0352',
  4, 90, '{}'::jsonb, 30, 'active', true,
  false, NULL, 7, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.486771, 31.304866), 4326),
  'Convenience-353', '地铁站口便利点 353', 'convenience', '地铁站口便利点 353（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0353',
  4, 90, '{}'::jsonb, 30, 'active', true,
  false, NULL, 104, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.550936, 31.228237), 4326),
  'Convenience-354', '夜宵街角点 354', 'convenience', '夜宵街角点 354（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0354',
  3, 75, '{}'::jsonb, 30, 'active', true,
  false, NULL, 89, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.376722, 31.224270), 4326),
  'Convenience-355', '夜宵街角点 355', 'convenience', '夜宵街角点 355（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0355',
  3, 71, '{}'::jsonb, 30, 'active', true,
  false, NULL, 38, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.501283, 31.319342), 4326),
  'Convenience-356', '夜宵街角点 356', 'convenience', '夜宵街角点 356（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0356',
  4, 66, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.503230, 31.309949), 4326),
  'Convenience-357', '便利店聚合点 357', 'convenience', '便利店聚合点 357（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0357',
  3, 76, '{}'::jsonb, 30, 'active', true,
  false, NULL, 21, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.415179, 31.160094), 4326),
  'Convenience-358', '夜宵街角点 358', 'convenience', '夜宵街角点 358（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0358',
  3, 79, '{}'::jsonb, 30, 'active', true,
  false, NULL, 71, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.383641, 31.277387), 4326),
  'Convenience-359', '地铁站口便利点 359', 'convenience', '地铁站口便利点 359（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0359',
  4, 60, '{}'::jsonb, 30, 'active', true,
  false, NULL, 37, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.551119, 31.246497), 4326),
  'Convenience-360', '便利店聚合点 360', 'convenience', '便利店聚合点 360（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0360',
  3, 78, '{}'::jsonb, 30, 'active', true,
  false, NULL, 8, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.526931, 31.267988), 4326),
  'Convenience-361', '夜宵街角点 361', 'convenience', '夜宵街角点 361（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0361',
  3, 80, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.516072, 31.321028), 4326),
  'Convenience-362', '地铁站口便利点 362', 'convenience', '地铁站口便利点 362（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0362',
  3, 88, '{}'::jsonb, 30, 'active', true,
  false, NULL, 8, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.479356, 31.166846), 4326),
  'Convenience-363', '夜宵街角点 363', 'convenience', '夜宵街角点 363（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0363',
  3, 93, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.418800, 31.188083), 4326),
  'Convenience-364', '地铁站口便利点 364', 'convenience', '地铁站口便利点 364（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0364',
  3, 82, '{}'::jsonb, 30, 'active', true,
  false, NULL, 15, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.497339, 31.230132), 4326),
  'Convenience-365', '社区超市点 365', 'convenience', '社区超市点 365（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0365',
  3, 72, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.480027, 31.181095), 4326),
  'Convenience-366', '社区超市点 366', 'convenience', '社区超市点 366（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0366',
  3, 89, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.96)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.516199, 31.279985), 4326),
  'Convenience-367', '社区超市点 367', 'convenience', '社区超市点 367（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0367',
  3, 88, '{}'::jsonb, 30, 'active', true,
  false, NULL, 28, 0.98)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.537164, 31.231471), 4326),
  'Convenience-368', '社区超市点 368', 'convenience', '社区超市点 368（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0368',
  4, 88, '{}'::jsonb, 30, 'active', true,
  false, NULL, 4, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.496131, 31.322305), 4326),
  'Convenience-369', '地铁站口便利点 369', 'convenience', '地铁站口便利点 369（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0369',
  2, 71, '{}'::jsonb, 30, 'active', true,
  false, NULL, 10, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.379372, 31.186202), 4326),
  'Convenience-370', '便利店聚合点 370', 'convenience', '便利店聚合点 370（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0370',
  3, 64, '{}'::jsonb, 30, 'active', true,
  false, NULL, 34, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.517849, 31.298860), 4326),
  'Convenience-371', '夜宵街角点 371', 'convenience', '夜宵街角点 371（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0371',
  3, 62, '{}'::jsonb, 30, 'active', true,
  false, NULL, 4, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.391897, 31.241708), 4326),
  'Convenience-372', '地铁站口便利点 372', 'convenience', '地铁站口便利点 372（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0372',
  4, 90, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.86)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.579070, 31.191412), 4326),
  'Convenience-373', '便利店聚合点 373', 'convenience', '便利店聚合点 373（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0373',
  3, 79, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.421727, 31.195026), 4326),
  'Convenience-374', '社区超市点 374', 'convenience', '社区超市点 374（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0374',
  3, 71, '{}'::jsonb, 30, 'active', true,
  false, NULL, 33, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.585813, 31.234468), 4326),
  'Convenience-375', '地铁站口便利点 375', 'convenience', '地铁站口便利点 375（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0375',
  2, 80, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.92)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.420202, 31.145613), 4326),
  'Convenience-376', '夜宵街角点 376', 'convenience', '夜宵街角点 376（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0376',
  3, 66, '{}'::jsonb, 30, 'active', true,
  false, NULL, 77, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.554479, 31.282206), 4326),
  'Convenience-377', '社区超市点 377', 'convenience', '社区超市点 377（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0377',
  4, 62, '{}'::jsonb, 30, 'active', true,
  false, NULL, 18, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.533287, 31.245407), 4326),
  'Convenience-378', '地铁站口便利点 378', 'convenience', '地铁站口便利点 378（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0378',
  3, 96, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.537503, 31.187631), 4326),
  'Convenience-379', '社区超市点 379', 'convenience', '社区超市点 379（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0379',
  3, 89, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.459592, 31.144807), 4326),
  'Convenience-380', '夜宵街角点 380', 'convenience', '夜宵街角点 380（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0380',
  3, 84, '{}'::jsonb, 30, 'active', true,
  false, NULL, 13, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.547466, 31.259852), 4326),
  'Convenience-381', '夜宵街角点 381', 'convenience', '夜宵街角点 381（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0381',
  3, 79, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.426604, 31.208681), 4326),
  'Convenience-382', '地铁站口便利点 382', 'convenience', '地铁站口便利点 382（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0382',
  4, 78, '{}'::jsonb, 30, 'active', true,
  false, NULL, 10, 0.98)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.396538, 31.165890), 4326),
  'Convenience-383', '便利店聚合点 383', 'convenience', '便利店聚合点 383（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0383',
  3, 82, '{}'::jsonb, 30, 'active', true,
  false, NULL, 24, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.495109, 31.144609), 4326),
  'Convenience-384', '夜宵街角点 384', 'convenience', '夜宵街角点 384（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0384',
  3, 98, '{}'::jsonb, 30, 'active', true,
  false, NULL, 13, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.435337, 31.271327), 4326),
  'Convenience-385', '地铁站口便利点 385', 'convenience', '地铁站口便利点 385（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0385',
  3, 80, '{}'::jsonb, 30, 'active', true,
  false, NULL, 16, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.456096, 31.165501), 4326),
  'Convenience-386', '地铁站口便利点 386', 'convenience', '地铁站口便利点 386（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0386',
  3, 91, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.567619, 31.188932), 4326),
  'Convenience-387', '地铁站口便利点 387', 'convenience', '地铁站口便利点 387（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0387',
  4, 94, '{}'::jsonb, 30, 'active', true,
  false, NULL, 6, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.492577, 31.235045), 4326),
  'Convenience-388', '社区超市点 388', 'convenience', '社区超市点 388（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0388',
  4, 74, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.62)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.381693, 31.219744), 4326),
  'Convenience-389', '便利店聚合点 389', 'convenience', '便利店聚合点 389（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0389',
  3, 70, '{}'::jsonb, 30, 'active', true,
  false, NULL, 20, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.448476, 31.325227), 4326),
  'Convenience-390', '便利店聚合点 390', 'convenience', '便利店聚合点 390（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0390',
  3, 84, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.415590, 31.234277), 4326),
  'Convenience-391', '便利店聚合点 391', 'convenience', '便利店聚合点 391（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0391',
  3, 62, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.549113, 31.192480), 4326),
  'Convenience-392', '便利店聚合点 392', 'convenience', '便利店聚合点 392（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0392',
  4, 82, '{}'::jsonb, 30, 'active', true,
  false, NULL, 11, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.381706, 31.206970), 4326),
  'Convenience-393', '社区超市点 393', 'convenience', '社区超市点 393（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0393',
  3, 65, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.405742, 31.277635), 4326),
  'Convenience-394', '社区超市点 394', 'convenience', '社区超市点 394（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0394',
  2, 73, '{}'::jsonb, 30, 'active', true,
  false, NULL, 29, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.424752, 31.244887), 4326),
  'Convenience-395', '夜宵街角点 395', 'convenience', '夜宵街角点 395（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0395',
  3, 62, '{}'::jsonb, 30, 'active', true,
  false, NULL, 5, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.514995, 31.150812), 4326),
  'Convenience-396', '地铁站口便利点 396', 'convenience', '地铁站口便利点 396（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0396',
  4, 74, '{}'::jsonb, 30, 'active', true,
  false, NULL, 16, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.502365, 31.223047), 4326),
  'Convenience-397', '便利店聚合点 397', 'convenience', '便利店聚合点 397（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0397',
  4, 91, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.467294, 31.211544), 4326),
  'Convenience-398', '地铁站口便利点 398', 'convenience', '地铁站口便利点 398（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0398',
  4, 77, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.449021, 31.242484), 4326),
  'Convenience-399', '便利店聚合点 399', 'convenience', '便利店聚合点 399（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0399',
  4, 80, '{}'::jsonb, 30, 'active', true,
  false, NULL, 40, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.397521, 31.176242), 4326),
  'Convenience-400', '地铁站口便利点 400', 'convenience', '地铁站口便利点 400（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0400',
  4, 85, '{}'::jsonb, 30, 'active', true,
  false, NULL, 22, 0.95)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.383753, 31.197563), 4326),
  'Convenience-401', '夜宵街角点 401', 'convenience', '夜宵街角点 401（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0401',
  3, 88, '{}'::jsonb, 30, 'active', true,
  false, NULL, 11, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.533407, 31.231719), 4326),
  'Convenience-402', '地铁站口便利点 402', 'convenience', '地铁站口便利点 402（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0402',
  4, 83, '{}'::jsonb, 30, 'active', true,
  false, NULL, 85, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.494601, 31.233125), 4326),
  'Convenience-403', '社区超市点 403', 'convenience', '社区超市点 403（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0403',
  4, 70, '{}'::jsonb, 30, 'active', true,
  false, NULL, 1, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.398995, 31.251711), 4326),
  'Convenience-404', '地铁站口便利点 404', 'convenience', '地铁站口便利点 404（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0404',
  3, 85, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.67)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.536675, 31.176510), 4326),
  'Convenience-405', '地铁站口便利点 405', 'convenience', '地铁站口便利点 405（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0405',
  4, 83, '{}'::jsonb, 30, 'active', true,
  false, NULL, 27, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.574783, 31.219880), 4326),
  'Convenience-406', '地铁站口便利点 406', 'convenience', '地铁站口便利点 406（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0406',
  3, 72, '{}'::jsonb, 30, 'active', true,
  false, NULL, 29, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.568333, 31.240137), 4326),
  'Convenience-407', '夜宵街角点 407', 'convenience', '夜宵街角点 407（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0407',
  3, 68, '{}'::jsonb, 30, 'active', true,
  false, NULL, 24, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.476767, 31.202578), 4326),
  'Convenience-408', '社区超市点 408', 'convenience', '社区超市点 408（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0408',
  4, 70, '{}'::jsonb, 30, 'active', true,
  false, NULL, 32, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.538065, 31.232754), 4326),
  'Convenience-409', '社区超市点 409', 'convenience', '社区超市点 409（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0409',
  3, 78, '{}'::jsonb, 30, 'active', true,
  false, NULL, 60, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.509945, 31.278770), 4326),
  'Convenience-410', '便利店聚合点 410', 'convenience', '便利店聚合点 410（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0410',
  3, 72, '{}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.98)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.536992, 31.214995), 4326),
  'Monument-411', '城市纪念雕塑 411', 'monument', '城市纪念雕塑 411（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0411',
  3, 85, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 39, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.510213, 31.180721), 4326),
  'Plaza-412', '音乐广场 412', 'plaza', '音乐广场 412（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0412',
  3, 78, '{"ferry_gap":true}'::jsonb, 50, 'active', true,
  false, NULL, 24, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.527205, 31.295692), 4326),
  'Convenience-413', '夜宵街角点 413', 'convenience', '夜宵街角点 413（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0413',
  3, 77, '{"ferry_gap":true}'::jsonb, 30, 'active', true,
  false, NULL, 0, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.519251, 31.259621), 4326),
  'Park-414', '街心花园 414', 'park', '街心花园 414（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0414',
  4, 69, '{"ferry_gap":true}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.510914, 31.216567), 4326),
  'Park-415', '社区花园 415', 'park', '社区花园 415（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0415',
  4, 56, '{"ferry_gap":true}'::jsonb, 60, 'active', false,
  false, NULL, 37, 0.98)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.524400, 31.309487), 4326),
  'Monument-416', '抗战纪念墙 416', 'monument', '抗战纪念墙 416（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0416',
  4, 79, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.526026, 31.310480), 4326),
  'Convenience-417', '社区超市点 417', 'convenience', '社区超市点 417（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0417',
  4, 95, '{"ferry_gap":true}'::jsonb, 30, 'active', true,
  false, NULL, 15, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.517972, 31.260898), 4326),
  'Museum-418', '唱片博物馆 418', 'museum', '唱片博物馆 418（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0418',
  4, 85, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 2, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.537258, 31.314940), 4326),
  'Monument-419', '城市纪念雕塑 419', 'monument', '城市纪念雕塑 419（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0419',
  4, 81, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 13, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.512767, 31.215846), 4326),
  'Convenience-420', '便利店聚合点 420', 'convenience', '便利店聚合点 420（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0420',
  4, 91, '{"ferry_gap":true}'::jsonb, 30, 'active', true,
  false, NULL, 10, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.531614, 31.272168), 4326),
  'Park-421', '口袋公园 421', 'park', '口袋公园 421（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0421',
  3, 73, '{"ferry_gap":true}'::jsonb, 60, 'active', false,
  false, NULL, 10, 0.77)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.544093, 31.208135), 4326),
  'Park-422', '街心花园 422', 'park', '街心花园 422（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0422',
  4, 91, '{"ferry_gap":true}'::jsonb, 60, 'active', false,
  false, NULL, 118, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.510684, 31.224963), 4326),
  'Plaza-423', '音乐广场 423', 'plaza', '音乐广场 423（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0423',
  4, 76, '{"ferry_gap":true}'::jsonb, 50, 'active', true,
  false, NULL, 27, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.571676, 31.207722), 4326),
  'Monument-424', '城市纪念雕塑 424', 'monument', '城市纪念雕塑 424（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0424',
  4, 74, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 3, 0.65)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.517724, 31.214806), 4326),
  'Monument-425', '艺术家雕像 425', 'monument', '艺术家雕像 425（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0425',
  4, 57, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 14, 0.78)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.524028, 31.281180), 4326),
  'Monument-426', '艺术家雕像 426', 'monument', '艺术家雕像 426（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0426',
  3, 80, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 12, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.540495, 31.223949), 4326),
  'Monument-427', '百年校址碑塔 427', 'monument', '百年校址碑塔 427（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0427',
  4, 94, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.87)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.515931, 31.223870), 4326),
  'Convenience-428', '便利店聚合点 428', 'convenience', '便利店聚合点 428（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0428',
  3, 77, '{"ferry_gap":true}'::jsonb, 30, 'active', true,
  false, NULL, 39, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.517437, 31.228688), 4326),
  'Museum-429', '弄堂记忆馆 429', 'museum', '弄堂记忆馆 429（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0429',
  3, 76, '{"ferry_gap":true}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.89)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.504509, 31.222203), 4326),
  'Convenience-430', '便利店聚合点 430', 'convenience', '便利店聚合点 430（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0430',
  5, 73, '{"ferry_gap":true}'::jsonb, 30, 'active', true,
  false, NULL, 39, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.429353, 31.191809), 4326),
  'Cemetery-431', '陵园 431', 'cemetery', '陵园 431（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0431',
  4, 92, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 23, 0.67)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.390087, 31.251746), 4326),
  'Cemetery-432', '陵园 432', 'cemetery', '陵园 432（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0432',
  4, 78, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 0, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.388232, 31.217794), 4326),
  'Cemetery-433', '陵园 433', 'cemetery', '陵园 433（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0433',
  3, 85, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 0, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.524041, 31.192057), 4326),
  'Cemetery-434', '纪念园(墓区) 434', 'cemetery', '纪念园(墓区) 434（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0434',
  4, 74, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 20, 0.9)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.495485, 31.210475), 4326),
  'Cemetery-435', '陵园 435', 'cemetery', '陵园 435（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0435',
  3, 62, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 3, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.542368, 31.193807), 4326),
  'Cemetery-436', '墓园 436', 'cemetery', '墓园 436（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0436',
  4, 87, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 13, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.372660, 31.213005), 4326),
  'Cemetery-437', '墓园 437', 'cemetery', '墓园 437（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0437',
  3, 87, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 22, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.503121, 31.282449), 4326),
  'Cemetery-438', '墓园 438', 'cemetery', '墓园 438（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0438',
  4, 91, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:cemetery (pre-applied)', 104, 0.76)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.470623, 31.296922), 4326),
  'Highway-439', '高架桥下空间 439', 'highway', '高架桥下空间 439（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0439',
  3, 77, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:highway (pre-applied)', 22, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.498705, 31.276515), 4326),
  'Highway-440', '高速服务区 440', 'highway', '高速服务区 440（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0440',
  3, 58, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:highway (pre-applied)', 7, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.420773, 31.212467), 4326),
  'Highway-441', '高架桥下空间 441', 'highway', '高架桥下空间 441（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0441',
  4, 75, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:highway (pre-applied)', 35, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.397060, 31.250261), 4326),
  'Highway-442', '高速服务区 442', 'highway', '高速服务区 442（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0442',
  3, 95, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:highway (pre-applied)', 0, 0.67)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.422635, 31.281361), 4326),
  'Highway-443', '高速服务区 443', 'highway', '高速服务区 443（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0443',
  3, 88, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:highway (pre-applied)', 30, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.515562, 31.318580), 4326),
  'Highway-444', '高架桥下空间 444', 'highway', '高架桥下空间 444（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0444',
  3, 61, '{}'::jsonb, 30, 'active', false,
  true, 'rule:blacklist_category:highway (pre-applied)', 38, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.532884, 31.195182), 4326),
  'Construction-445', '围挡施工区 445', 'construction', '围挡施工区 445（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0445',
  3, 70, '{}'::jsonb, 30, 'active', false,
  false, NULL, 36, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.560862, 31.240338), 4326),
  'Construction-446', '围挡施工区 446', 'construction', '围挡施工区 446（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0446',
  3, 76, '{}'::jsonb, 30, 'active', false,
  false, NULL, 101, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.489853, 31.230572), 4326),
  'Construction-447', '围挡施工区 447', 'construction', '围挡施工区 447（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0447',
  2, 85, '{}'::jsonb, 30, 'active', false,
  false, NULL, 37, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.458758, 31.150878), 4326),
  'Construction-448', '在建工地 448', 'construction', '在建工地 448（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0448',
  3, 67, '{}'::jsonb, 30, 'active', false,
  false, NULL, 21, 0.63)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.531469, 31.291982), 4326),
  'Construction-449', '围挡施工区 449', 'construction', '围挡施工区 449（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0449',
  4, 72, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.464656, 31.243859), 4326),
  'Construction-450', '拆迁区块 450', 'construction', '拆迁区块 450（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0450',
  4, 67, '{}'::jsonb, 30, 'active', false,
  false, NULL, 96, 0.81)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.402058, 31.184918), 4326),
  'Construction-451', '拆迁区块 451', 'construction', '拆迁区块 451（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0451',
  3, 75, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.66)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.417973, 31.190885), 4326),
  'Construction-452', '在建工地 452', 'construction', '在建工地 452（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0452',
  3, 76, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.67)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.504701, 31.157551), 4326),
  'Park-453', '街心花园 453', 'park', '街心花园 453（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0453',
  3, 81, '{"island":true}'::jsonb, 60, 'active', false,
  false, NULL, 37, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.560099, 31.262510), 4326),
  'Park-454', '街心花园 454', 'park', '街心花园 454（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0454',
  3, 89, '{"island":true}'::jsonb, 60, 'active', false,
  false, NULL, 6, 0.93)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.446222, 31.315967), 4326),
  'Park-455', '梧桐绿地 455', 'park', '梧桐绿地 455（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0455',
  4, 68, '{"island":true}'::jsonb, 60, 'active', false,
  false, NULL, 0, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.545224, 31.205809), 4326),
  'Park-456', '口袋公园 456', 'park', '口袋公园 456（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0456',
  4, 90, '{"island":true}'::jsonb, 60, 'active', false,
  false, NULL, 16, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.467918, 31.233104), 4326),
  'Monument-457', '艺术家雕像 457', 'monument', '艺术家雕像 457（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0457',
  3, 88, '{"rail_within_50m":true}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.84)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.518445, 31.257113), 4326),
  'Monument-458', '工人纪念碑 458', 'monument', '工人纪念碑 458（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0458',
  4, 93, '{"rail_within_50m":true}'::jsonb, 30, 'active', false,
  false, NULL, 16, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.382224, 31.270952), 4326),
  'Monument-459', '工人纪念碑 459', 'monument', '工人纪念碑 459（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0459',
  3, 59, '{"rail_within_50m":true}'::jsonb, 30, 'active', false,
  false, NULL, 29, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.481156, 31.242588), 4326),
  'Monument-460', '工人纪念碑 460', 'monument', '工人纪念碑 460（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0460',
  3, 92, '{"rail_within_50m":true}'::jsonb, 30, 'active', false,
  false, NULL, 7, 0.85)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.538261, 31.174022), 4326),
  'Plaza-461', '音乐广场 461', 'plaza', '音乐广场 461（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0461',
  3, 86, '{}'::jsonb, 50, 'auto', true,
  false, NULL, 35, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.417057, 31.295570), 4326),
  'Convenience-462', '社区超市点 462', 'convenience', '社区超市点 462（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0462',
  3, 71, '{}'::jsonb, 30, 'auto', true,
  false, NULL, 33, 0.71)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.581843, 31.227383), 4326),
  'Monument-463', '抗战纪念墙 463', 'monument', '抗战纪念墙 463（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0463',
  2, 80, '{}'::jsonb, 30, 'auto', false,
  false, NULL, 0, 0.74)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.375556, 31.194747), 4326),
  'Convenience-464', '夜宵街角点 464', 'convenience', '夜宵街角点 464（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0464',
  3, 71, '{}'::jsonb, 30, 'auto', true,
  false, NULL, 65, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.565341, 31.282232), 4326),
  'Convenience-465', '便利店聚合点 465', 'convenience', '便利店聚合点 465（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0465',
  3, 82, '{}'::jsonb, 30, 'auto', true,
  false, NULL, 32, 0.83)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.494330, 31.262136), 4326),
  'Convenience-466', '地铁站口便利点 466', 'convenience', '地铁站口便利点 466（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0466',
  3, 97, '{}'::jsonb, 30, 'auto', true,
  false, NULL, 40, 0.64)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.387841, 31.250297), 4326),
  'Plaza-467', '喷泉广场 467', 'plaza', '喷泉广场 467（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0467',
  4, 64, '{}'::jsonb, 50, 'auto', true,
  false, NULL, 16, 0.91)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.541416, 31.274359), 4326),
  'Park-468', '街心花园 468', 'park', '街心花园 468（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0468',
  4, 67, '{}'::jsonb, 60, 'auto', false,
  false, NULL, 7, 0.8)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.410715, 31.195326), 4326),
  'Park-469', '口袋公园 469', 'park', '口袋公园 469（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0469',
  3, 67, '{}'::jsonb, 60, 'auto', false,
  false, NULL, 21, 0.73)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.485676, 31.280290), 4326),
  'Park-470', '梧桐绿地 470', 'park', '梧桐绿地 470（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0470',
  4, 71, '{}'::jsonb, 60, 'auto', false,
  false, NULL, 33, 0.79)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.567128, 31.239033), 4326),
  'Monument-471', '百年校址碑塔 471', 'monument', '百年校址碑塔 471（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0471',
  3, 68, '{}'::jsonb, 30, 'auto', false,
  false, NULL, 21, 0.88)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.499541, 31.275987), 4326),
  'Park-472', '滨江小园 472', 'park', '滨江小园 472（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0472',
  3, 73, '{}'::jsonb, 60, 'auto', false,
  false, NULL, 0, 0.7)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.437870, 31.148355), 4326),
  'Park-473', '社区花园 473', 'park', '社区花园 473（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0473',
  4, 64, '{}'::jsonb, 60, 'auto', false,
  false, NULL, 33, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.470039, 31.188970), 4326),
  'Plaza-474', '喷泉广场 474', 'plaza', '喷泉广场 474（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0474',
  4, 69, '{}'::jsonb, 50, 'auto', true,
  false, NULL, 3, 0.72)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.451953, 31.195249), 4326),
  'Park-475', '滨江小园 475', 'park', '滨江小园 475（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0475',
  4, 84, '{}'::jsonb, 60, 'auto', false,
  false, NULL, 32, 0.68)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.478541, 31.163819), 4326),
  'Convenience-476', '夜宵街角点 476', 'convenience', '夜宵街角点 476（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0476',
  3, 63, '{}'::jsonb, 30, 'auto', true,
  false, NULL, 1, 0.75)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.553926, 31.301433), 4326),
  'Plaza-477', '喷泉广场 477', 'plaza', '喷泉广场 477（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0477',
  3, 61, '{}'::jsonb, 50, 'auto', true,
  false, NULL, 7, 0.97)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.504719, 31.240077), 4326),
  'Convenience-478', '地铁站口便利点 478', 'convenience', '地铁站口便利点 478（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0478',
  3, 98, '{}'::jsonb, 30, 'auto', true,
  false, NULL, 26, 0.94)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.484677, 31.287400), 4326),
  'Convenience-479', '便利店聚合点 479', 'convenience', '便利店聚合点 479（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0479',
  4, 96, '{}'::jsonb, 30, 'auto', true,
  false, NULL, 5, 0.82)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.498816, 31.174494), 4326),
  'Plaza-480', '站前广场 480', 'plaza', '站前广场 480（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'auto', 'seed:0480',
  4, 96, '{}'::jsonb, 50, 'auto', false,
  false, NULL, 4, 0.69)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.531849, 31.259282), 4326),
  'Stone-481', '老码头界碑 481', 'landmark_stone', '老码头界碑 481（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0481',
  4, 78, '{}'::jsonb, 20, 'retired', false,
  false, NULL, 0, 0.45)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.442689, 31.296646), 4326),
  'Stone-482', '老码头界碑 482', 'landmark_stone', '老码头界碑 482（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0482',
  3, 79, '{}'::jsonb, 20, 'retired', false,
  false, NULL, 7, 0.51)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.544913, 31.294160), 4326),
  'Temple-483', '老城隍庙 483', 'shrine', '老城隍庙 483（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0483',
  3, 54, '{}'::jsonb, 30, 'retired', false,
  false, NULL, 0, 0.41)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.379988, 31.213406), 4326),
  'Stone-484', '里坊铭牌 484', 'landmark_stone', '里坊铭牌 484（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0484',
  3, 56, '{}'::jsonb, 20, 'retired', false,
  false, NULL, 12, 0.55)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.462744, 31.193052), 4326),
  'Stone-485', '商号旧址碑 485', 'landmark_stone', '商号旧址碑 485（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0485',
  3, 60, '{}'::jsonb, 20, 'retired', false,
  false, NULL, 37, 0.54)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.492602, 31.215291), 4326),
  'Stone-486', '商号旧址碑 486', 'landmark_stone', '商号旧址碑 486（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0486',
  3, 55, '{}'::jsonb, 20, 'retired', false,
  false, NULL, 0, 0.36)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.435733, 31.260753), 4326),
  'Temple-487', '老城隍庙 487', 'shrine', '老城隍庙 487（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0487',
  4, 59, '{}'::jsonb, 30, 'retired', false,
  false, NULL, 29, 0.47)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.499073, 31.276480), 4326),
  'Stone-488', '老码头界碑 488', 'landmark_stone', '老码头界碑 488（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0488',
  3, 81, '{}'::jsonb, 20, 'retired', false,
  false, NULL, 2, 0.51)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.519142, 31.306216), 4326),
  'Stone-489', '里坊铭牌 489', 'landmark_stone', '里坊铭牌 489（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0489',
  3, 53, '{}'::jsonb, 20, 'retired', false,
  false, NULL, 37, 0.38)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.542207, 31.169529), 4326),
  'Temple-490', '基督教堂 490', 'shrine', '基督教堂 490（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0490',
  3, 71, '{}'::jsonb, 30, 'retired', false,
  false, NULL, 33, 0.43)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.471998, 31.224895), 4326),
  'Stone-491', '桥梁奠基石 491', 'landmark_stone', '桥梁奠基石 491（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0491',
  3, 74, '{}'::jsonb, 20, 'active', false,
  false, NULL, 12, 0.48)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.445159, 31.206238), 4326),
  'Stone-492', '里坊铭牌 492', 'landmark_stone', '里坊铭牌 492（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0492',
  3, 86, '{}'::jsonb, 20, 'active', false,
  false, NULL, 40, 0.57)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.397112, 31.213313), 4326),
  'Stone-493', '老码头界碑 493', 'landmark_stone', '老码头界碑 493（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0493',
  3, 52, '{}'::jsonb, 20, 'active', false,
  false, NULL, 1, 0.51)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.583043, 31.252987), 4326),
  'Monument-494', '城市纪念雕塑 494', 'monument', '城市纪念雕塑 494（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0494',
  4, 75, '{}'::jsonb, 30, 'active', false,
  false, NULL, 37, 0.52)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.494196, 31.177067), 4326),
  'Stone-495', '古城墙残碑 495', 'landmark_stone', '古城墙残碑 495（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0495',
  4, 61, '{}'::jsonb, 20, 'active', false,
  false, NULL, 38, 0.5)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.410988, 31.162487), 4326),
  'Stone-496', '里坊铭牌 496', 'landmark_stone', '里坊铭牌 496（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0496',
  3, 66, '{}'::jsonb, 20, 'active', false,
  false, NULL, 0, 0.46)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.555720, 31.248935), 4326),
  'Monument-497', '百年校址碑塔 497', 'monument', '百年校址碑塔 497（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0497',
  4, 64, '{}'::jsonb, 30, 'active', false,
  false, NULL, 14, 0.54)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.473426, 31.315134), 4326),
  'Stone-498', '商号旧址碑 498', 'landmark_stone', '商号旧址碑 498（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0498',
  3, 68, '{}'::jsonb, 20, 'active', false,
  false, NULL, 20, 0.46)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.472060, 31.255899), 4326),
  'Monument-499', '艺术家雕像 499', 'monument', '艺术家雕像 499（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0499',
  4, 78, '{}'::jsonb, 30, 'active', false,
  false, NULL, 103, 0.52)
ON CONFLICT (source_ref) DO NOTHING;
INSERT INTO poi (geom, name, name_local, category, description, photos, source, source_ref,
  editor_score, safety_score, accessibility, fence_radius_m, status, open_24h, blacklisted, blacklist_reason,
  visit_count_90d, arrive_rate)
VALUES (ST_SetSRID(ST_MakePoint(121.578265, 31.201093), 4326),
  'Monument-500', '抗战纪念墙 500', 'monument', '抗战纪念墙 500（生成种子数据，用于原型验证，非真实地点）', '{}'::text[],
  'seed', 'seed:0500',
  3, 61, '{}'::jsonb, 30, 'active', false,
  false, NULL, 0, 0.46)
ON CONFLICT (source_ref) DO NOTHING;

-- 应用黑名单规则（幂等）: 会把 construction 类与 island/rail 标记的 POI 刷成 blacklisted=true
SELECT fn_refresh_blacklist() AS blacklist_refreshed;

-- 校验汇总
SELECT count(*)                                        AS total_pois        FROM poi
UNION ALL SELECT count(*)                              FROM poi WHERE blacklisted
UNION ALL SELECT count(*)                              FROM v_poi_active
UNION ALL SELECT count(*)                              FROM poi WHERE status = 'auto';

COMMIT;

