USE wms;

INSERT INTO items
(item_name, item_price, item_volume, item_category, item_img)
VALUES
-- HEALTH
('프로틴 바닐라',     35000, 3, 'HEALTH',  NULL),
('비타민팩',         18000,   3, 'HEALTH',  NULL),
('오메가3',          26000,  1, 'HEALTH',  NULL),
('BCAA 정제',        22000,  2, 'HEALTH',  NULL),
('전해질 스틱',      14000,   2, 'HEALTH',  NULL),

-- BEAUTY
('수분크림',         22000,  2, 'BEAUTY',  NULL),
('히알 세럼',        28000,   2, 'BEAUTY',  NULL),
('비타C 토너',       19000,  2, 'BEAUTY',  NULL),
('수딩젤',           12000,  3, 'BEAUTY',  NULL),
('선크림 SPF50+',    17000,   1, 'BEAUTY',  NULL),

-- PERFUME
('시트러스 EDT',     54000,  2, 'PERFUME', NULL),
('플로럴 EDP',       68000,   1, 'PERFUME', NULL),
('프레시 바디미스트', 18000,  1, 'PERFUME', NULL),
('우디 솔리드',      22000,   1, 'PERFUME', NULL),
('디퓨저',           30000,  1, 'PERFUME', NULL),

-- CARE
('핸드워시',          8000,  1, 'CARE',    NULL),
('핸드크림',          6000,   1, 'CARE',    NULL),
('샴푸',             15000,  2, 'CARE',    NULL),
('컨디셔너',         15000,  2, 'CARE',    NULL),
('바디로션',         16000,  2, 'CARE',    NULL),

-- FOOD
('아몬드',            9000,  2, 'FOOD',    NULL),
('믹스넛',           15000,  3, 'FOOD',    NULL),
('프로틴바',         18000,   3, 'FOOD',    NULL),
('그래놀라',         11000,  2, 'FOOD',    NULL),
('호두',             12000,  2, 'FOOD',    NULL);
