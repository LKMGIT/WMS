USE wms;

INSERT INTO items
(item_name, item_price, item_volume, item_category, item_img)
VALUES
-- HEALTH
('프로틴 바닐라',     35000, 1200, 'HEALTH',  NULL),
('비타민팩',         18000,   30, 'HEALTH',  NULL),
('오메가3',          26000,  180, 'HEALTH',  NULL),
('BCAA 정제',        22000,  240, 'HEALTH',  NULL),
('전해질 스틱',      14000,   20, 'HEALTH',  NULL),

-- BEAUTY
('수분크림',         22000,  200, 'BEAUTY',  NULL),
('히알 세럼',        28000,   50, 'BEAUTY',  NULL),
('비타C 토너',       19000,  250, 'BEAUTY',  NULL),
('수딩젤',           12000,  300, 'BEAUTY',  NULL),
('선크림 SPF50+',    17000,   70, 'BEAUTY',  NULL),

-- PERFUME
('시트러스 EDT',     54000,  100, 'PERFUME', NULL),
('플로럴 EDP',       68000,   50, 'PERFUME', NULL),
('프레시 바디미스트', 18000,  150, 'PERFUME', NULL),
('우디 솔리드',      22000,   10, 'PERFUME', NULL),
('디퓨저',           30000,  200, 'PERFUME', NULL),

-- CARE
('핸드워시',          8000,  300, 'CARE',    NULL),
('핸드크림',          6000,   50, 'CARE',    NULL),
('샴푸',             15000,  500, 'CARE',    NULL),
('컨디셔너',         15000,  500, 'CARE',    NULL),
('바디로션',         16000,  400, 'CARE',    NULL),

-- FOOD
('아몬드',            9000,  500, 'FOOD',    NULL),
('믹스넛',           15000,  800, 'FOOD',    NULL),
('프로틴바',         18000,   12, 'FOOD',    NULL),
('그래놀라',         11000,  500, 'FOOD',    NULL),
('호두',             12000,  400, 'FOOD',    NULL);
