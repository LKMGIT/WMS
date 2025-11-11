USE wms;

USE wms;

USE wms;

-- 프로틴 바닐라
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 1, 101,
       120, NOW() - INTERVAL 3 DAY, NULL,
       9001, NULL
FROM items WHERE item_name='프로틴 바닐라';

-- 비타민팩
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 1, 101,
       80, NOW() - INTERVAL 2 DAY, NULL,
       9002, NULL
FROM items WHERE item_name='비타민팩';

-- 오메가3
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 1, 102,
       60, NOW() - INTERVAL 5 DAY, NULL,
       9003, NULL
FROM items WHERE item_name='오메가3';

-- 히알 세럼
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 1, 102,
       75, NOW() - INTERVAL 4 DAY, NULL,
       9004, NULL
FROM items WHERE item_name='히알 세럼';

-- 수분크림
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 2, 201,
       200, NOW() - INTERVAL 1 DAY, NULL,
       9005, NULL
FROM items WHERE item_name='수분크림';

-- 플로럴 EDP
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 2, 201,
       35, NOW() - INTERVAL 7 DAY, NULL,
       9006, NULL
FROM items WHERE item_name='플로럴 EDP';

-- 시트러스 EDT
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 2, 202,
       50, NOW() - INTERVAL 6 DAY, NULL,
       9007, NULL
FROM items WHERE item_name='시트러스 EDT';

-- 샴푸
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 1, 101,
       180, NOW() - INTERVAL 3 DAY, NULL,
       9008, NULL
FROM items WHERE item_name='샴푸';

-- 컨디셔너
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 1, 102,
       170, NOW() - INTERVAL 3 DAY, NULL,
       9009, NULL
FROM items WHERE item_name='컨디셔너';

-- 프로틴바
INSERT INTO inventory
(item_index, warehouse_index, section_index,
 inven_quantity, inbound_date, shipping_date,
 detail_inbound, detail_outbound)
SELECT item_index, 2, 202,
       150, NOW() - INTERVAL 8 DAY, NULL,
       9010, NULL
FROM items WHERE item_name='프로틴바';



SELECT inv.inven_index, inv.warehouse_index, inv.section_index,
       i.item_name, i.item_category, inv.inven_quantity, inv.inbound_date
FROM inventory inv
         JOIN items i ON i.item_index = inv.item_index
ORDER BY inv.inven_index DESC;



-- 동일 키 조합 중복 카운트 보기
SELECT item_index, warehouse_index, section_index, COUNT(*) AS cnt, SUM(inven_quantity) AS sum_qty
FROM inventory
GROUP BY item_index, warehouse_index, section_index
HAVING cnt > 1;

-- 변경된 재고 확인
SELECT * FROM inventory ORDER BY inven_index DESC;

-- 스냅샷(실재고) 누적 확인
SELECT * FROM inven_count ORDER BY count_index DESC;
