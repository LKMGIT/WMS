use wms;


USE wms;

-- 1) 프로틴 바닐라 (창고1-101): 재고 120 → 실사 118 (-2)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 118, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='프로틴 바닐라' AND inv.warehouse_index=1 AND inv.section_index=101
LIMIT 1;

-- 2) 비타민팩 (창고1-101): 80 → 80 (±0)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 80, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='비타민팩' AND inv.warehouse_index=1 AND inv.section_index=101
LIMIT 1;

-- 3) 오메가3 (창고1-102): 60 → 62 (+2)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 62, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='오메가3' AND inv.warehouse_index=1 AND inv.section_index=102
LIMIT 1;

-- 4) 히알 세럼 (창고1-102): 75 → 74 (-1)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 74, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='히알 세럼' AND inv.warehouse_index=1 AND inv.section_index=102
LIMIT 1;

-- 5) 수분크림 (창고2-201): 200 → 200 (±0)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 200, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='수분크림' AND inv.warehouse_index=2 AND inv.section_index=201
LIMIT 1;

-- 6) 플로럴 EDP (창고2-201): 35 → 36 (+1)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 36, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='플로럴 EDP' AND inv.warehouse_index=2 AND inv.section_index=201
LIMIT 1;

-- 7) 시트러스 EDT (창고2-202): 50 → 49 (-1)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 49, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='시트러스 EDT' AND inv.warehouse_index=2 AND inv.section_index=202
LIMIT 1;

-- 8) 샴푸 (창고1-101): 180 → 179 (-1)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 179, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='샴푸' AND inv.warehouse_index=1 AND inv.section_index=101
LIMIT 1;

-- 9) 컨디셔너 (창고1-102): 170 → 170 (±0)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 170, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='컨디셔너' AND inv.warehouse_index=1 AND inv.section_index=102
LIMIT 1;

-- 10) 프로틴바 (창고2-202): 150 → 151 (+1)
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
SELECT inv.inven_index, inv.inven_quantity, 151, NOW()
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name='프로틴바' AND inv.warehouse_index=2 AND inv.section_index=202
LIMIT 1;


-- 실사 목록
SELECT c.count_index, c.inven_index, c.inven_quantity, c.actual_quantity, c.count_updateAt
FROM inven_count c
ORDER BY c.count_index DESC;

-- (옵션) 실사 + 품목명 같이 보기
SELECT c.count_index, c.inven_index,
       i.item_name, i.item_category,
       c.inven_quantity, c.actual_quantity, c.count_updateAt
FROM inven_count c
         JOIN inventory inv ON inv.inven_index = c.inven_index
         JOIN items i ON i.item_index = inv.item_index
ORDER BY c.count_index DESC;

DELETE c FROM inven_count c
                  JOIN inventory inv ON inv.inven_index = c.inven_index
                  JOIN items i ON i.item_index = inv.item_index
WHERE i.item_name IN ('프로틴 바닐라','비타민팩','오메가3','히알 세럼','수분크림',
                      '플로럴 EDP','시트러스 EDT','샴푸','컨디셔너','프로틴바');
