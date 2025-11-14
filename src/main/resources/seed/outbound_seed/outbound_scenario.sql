USE wms;

-- =================================================================
-- 0. 모든 테이블 데이터 초기화 (FK 제약 역순으로)
-- =================================================================
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Waybill;
TRUNCATE TABLE ShippingInstruction;
TRUNCATE TABLE Dispatch;
TRUNCATE TABLE OutboundRequest;
TRUNCATE TABLE inven_count;
TRUNCATE TABLE inbound_detail;
TRUNCATE TABLE inbound_request;
TRUNCATE TABLE inventory;
TRUNCATE TABLE VehicleLocation;
TRUNCATE TABLE Vehicle;
TRUNCATE TABLE section;
TRUNCATE TABLE warehouse;
TRUNCATE TABLE items;
SET FOREIGN_KEY_CHECKS = 1;

-- AUTO_INCREMENT 초기화
ALTER TABLE warehouse AUTO_INCREMENT = 1;
ALTER TABLE section AUTO_INCREMENT = 1;
ALTER TABLE items AUTO_INCREMENT = 1;
ALTER TABLE Vehicle AUTO_INCREMENT = 1;
ALTER TABLE VehicleLocation AUTO_INCREMENT = 1;
ALTER TABLE inbound_request AUTO_INCREMENT = 1;
ALTER TABLE inbound_detail AUTO_INCREMENT = 1;
ALTER TABLE inventory AUTO_INCREMENT = 1;
ALTER TABLE inven_count AUTO_INCREMENT = 1;
ALTER TABLE OutboundRequest AUTO_INCREMENT = 1;
ALTER TABLE Dispatch AUTO_INCREMENT = 1;
ALTER TABLE ShippingInstruction AUTO_INCREMENT = 1;
ALTER TABLE Waybill AUTO_INCREMENT = 1;

-- =================================================================
-- 1. 기본 데이터 생성 (제공된 SQL 기준)
-- =================================================================
-- 1-1. 창고 (Warehouse)
insert into warehouse(warehouse_code, warehouse_name, warehouse_size, warehouse_createdAt, warehouse_updatedAt,
                      warehouse_location, warehouse_address, warehouse_zipcode, warehouse_status)
values (1, '강남창고', 1000, NOW(), NOW(),
        '서울특별시', '서울 강남구 삼성로 534', '06166', 'NORMAL'),
       (2, '구로창고', 2000, NOW(), NOW(),
        '서울특별시', '서울 구로구 디지털로26길 72', '08393', 'NORMAL'),
       (3, '수원창고', 3000, NOW(), NOW(),
        '경기', '경기 수원시 영통구 광교중앙로 145', '16509', 'NORMAL'),
       (4, '천안창고', 1800, NOW(), NOW(),
        '충남', '충남 천안시 동남구 목천읍 천안대로 2-10', '31226', 'NORMAL');

-- 1-2. 섹션 (Section)
insert into section
(section_code, section_name, section_capacity, warehouse_index)
values
    (101, 'S-1', 333, 1), (102, 'S-2', 333, 1), (103, 'S-3', 334, 1),
    (201, 'S-1', 500, 2), (202, 'S-2', 500, 2), (203, 'S-3', 500, 2), (204, 'S-4', 500, 2),
    (301, 'S-1', 600, 3), (302, 'S-2', 600, 3), (303, 'S-3', 600, 3), (304, 'S-4', 600, 3), (305, 'S-5', 600, 3),
    (401, 'S-1', 450, 4), (402, 'S-2', 450, 4), (403, 'S-3', 450, 4), (404, 'S-4', 450, 4);

-- 1-3. 아이템 (Items) - (inbound_index 컬럼 제외)
INSERT INTO items (item_name, item_price, item_volume, item_category)
VALUES
    ('(A) 핸드크림 50ml', 5000, 1, 'BEAUTY'),
    ('(B) 대용량 샴푸 1L', 15000, 3, 'CARE'),
    ('(C) 수딩 토너 200ml', 12000, 2, 'BEAUTY');

-- 1-4. 차량 (Vehicle)
INSERT INTO Vehicle (vehicle_name, vehicle_id, vehicle_volume, driver_name, driver_phone)
VALUES
    ('2.5톤 트럭 (서울 A)', '12가 1001', 100, '호날두','010-1111-0001'),
    ('2.5톤 트럭 (서울 B)', '12가 1002', 100, '메시', '010-1111-0002' ),
    ('2.5톤 트럭 (서울 C)', '12가 1003', 100,  '라모스', '010-1111-0003'),
    ('5톤 윙바디 (서울 D)', '12가 1004', 100, '베컴', '010-1111-0004'),
    ('2.5톤 트럭 (서울 E)', '12가 1005', 100, '크로스', '010-1111-0005'),
    ('2.5톤 트럭 (경기 A)', '12가 1006', 100, '김덕배', '010-1111-0006'),
    ('2.5톤 트럭 (경기 B)', '12가 1007', 100, '콤파니', '010-1111-0007'),
    ('5톤 윙바디 (경기 C)', '12가 1008', 200,  '밀리탕', '010-1111-0008'),
    ('2.5톤 트럭 (경기 D)', '12가 1009', 100, '음바페', '010-1111-0009'),
    ('2.5톤 트럭 (충남 A)', '12가 1010', 100, '알라바','010-1111-0010'),
    ('2.5톤 트럭 (충남 B)', '12가 1011', 100, '손흥민', '010-1111-0011');

-- 1-5. 차량 위치 (VehicleLocation)
INSERT INTO VehicleLocation (vehicle_index, vl_zip_code)
VALUES
    (1, '01'), (1, '02'), (1, '03'), (2, '02'), (2, '03'), (2, '04'), (3, '04'), (3, '05'), (3, '06'), (4, '06'), (4, '07'), (4, '08'), (5, '08'), (5, '09'), (5, '01'),
    (6, '10'), (6, '11'), (6, '12'), (6, '13'), (7, '12'), (7, '13'), (7, '14'), (7, '15'), (8, '15'), (8, '16'), (8, '17'), (8, '18'), (9, '17'), (9, '18'), (9, '10'), (9, '11'),
    (10, '31'), (10, '32'), (11, '32'), (11, '33');

-- =================================================================
-- 2. 입고 100건 생성 (재고 확보)
-- =================================================================

-- (1~60번) "완전 입고" 프로시저
DELIMITER $$
CREATE PROCEDURE `sp_insert_completed_inbounds`(IN start_id INT, IN end_id INT)
BEGIN
    DECLARE i INT DEFAULT start_id;
    DECLARE v_user_index BIGINT;
    DECLARE v_item_index BIGINT;
    DECLARE v_wh_index INT;
    DECLARE v_sec_index_pk BIGINT;
    DECLARE v_sec_code INT;
    DECLARE v_qty INT;
    DECLARE v_req_date DATETIME;
    DECLARE v_plan_date DATE;
    DECLARE v_approve_date DATETIME;
    DECLARE v_complete_date DATETIME;
    DECLARE v_inbound_idx BIGINT;

    SET @users = '1,2,6,10,11,15,21,26,31,34,36,39,44,46,49,54,56,59,64,66';

    WHILE i <= end_id DO
        SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (i % 20) + 1), ',', -1) AS UNSIGNED);
        SET v_item_index = (i % 25) + 1;
        SET v_wh_index = (i % 4) + 1;

SELECT section_index, section_code INTO v_sec_index_pk, v_sec_code
FROM section WHERE warehouse_index = v_wh_index ORDER BY RAND() LIMIT 1;

SET v_qty = ((i % 5) + 2) * 50; -- 100~300

        SET v_req_date = DATE_SUB('2025-09-01 10:00:00', INTERVAL (60-i) DAY);
        SET v_plan_date = DATE(DATE_ADD(v_req_date, INTERVAL 3 DAY));
        SET v_approve_date = DATE_ADD(v_req_date, INTERVAL 1 DAY);
        SET v_complete_date = DATE_ADD(v_approve_date, INTERVAL 3 DAY);

INSERT INTO inbound_request (inbound_request_quantity, inbound_request_date, planned_receive_date, approval_status, approve_date, user_index, warehouse_index, item_index)
VALUES (v_qty, v_req_date, v_plan_date, 'APPROVED', v_approve_date, v_user_index, v_wh_index, v_item_index);

SET v_inbound_idx = LAST_INSERT_ID();

INSERT INTO inbound_detail (inbound_index, received_quantity, complete_date, warehouse_index, section_index)
VALUES (v_inbound_idx, v_qty, v_complete_date, v_wh_index, CAST(v_sec_code AS CHAR));

INSERT INTO inventory (item_index, warehouse_index, section_index, inven_quantity, inbound_date, detail_inbound)
VALUES (v_item_index, v_wh_index, v_sec_index_pk, v_qty, v_complete_date, v_inbound_idx)
    ON DUPLICATE KEY UPDATE inven_quantity = inven_quantity + VALUES(inven_quantity), inbound_date = VALUES(inbound_date), detail_inbound = VALUES(detail_inbound);

SET i = i + 1;
END WHILE;
END$$
DELIMITER ;
CALL sp_insert_completed_inbounds(1, 60);
DROP PROCEDURE sp_insert_completed_inbounds;

-- (61~70번) "부분 입고" 프로시저
DELIMITER $$
CREATE PROCEDURE `sp_insert_partial_inbounds`(IN start_id INT, IN end_id INT)
BEGIN
    DECLARE i INT DEFAULT start_id;
    DECLARE v_user_index BIGINT;
    DECLARE v_item_index BIGINT;
    DECLARE v_wh_index INT;
    DECLARE v_sec_index_pk BIGINT;
    DECLARE v_sec_code INT;
    DECLARE v_req_qty INT;
    DECLARE v_recv_qty INT;
    DECLARE v_req_date DATETIME;
    DECLARE v_plan_date DATE;
    DECLARE v_approve_date DATETIME;
    DECLARE v_complete_date DATETIME;
    DECLARE v_inbound_idx BIGINT;

    SET @users = '1,2,6,10,11,15,21,26,31,34';

    WHILE i <= end_id DO
        SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (i % 10) + 1), ',', -1) AS UNSIGNED);
        SET v_item_index = (i % 25) + 1;
        SET v_wh_index = (i % 4) + 1;

SELECT section_index, section_code INTO v_sec_index_pk, v_sec_code
FROM section WHERE warehouse_index = v_wh_index ORDER BY RAND() LIMIT 1;

SET v_req_qty = 300;
        SET v_recv_qty = 100;

        SET v_req_date = DATE_SUB('2025-09-15 11:00:00', INTERVAL (70-i) DAY);
        SET v_plan_date = DATE(DATE_ADD(v_req_date, INTERVAL 3 DAY));
        SET v_approve_date = DATE_ADD(v_req_date, INTERVAL 1 DAY);
        SET v_complete_date = DATE_ADD(v_approve_date, INTERVAL 3 DAY);

INSERT INTO inbound_request (inbound_request_quantity, inbound_request_date, planned_receive_date, approval_status, approve_date, user_index, warehouse_index, item_index)
VALUES (v_req_qty, v_req_date, v_plan_date, 'APPROVED', v_approve_date, v_user_index, v_wh_index, v_item_index);

SET v_inbound_idx = LAST_INSERT_ID();

INSERT INTO inbound_detail (inbound_index, received_quantity, complete_date, warehouse_index, section_index)
VALUES (v_inbound_idx, v_recv_qty, v_complete_date, v_wh_index, CAST(v_sec_code AS CHAR));

INSERT INTO inventory (item_index, warehouse_index, section_index, inven_quantity, inbound_date, detail_inbound)
VALUES (v_item_index, v_wh_index, v_sec_index_pk, v_recv_qty, v_complete_date, v_inbound_idx)
    ON DUPLICATE KEY UPDATE inven_quantity = inven_quantity + VALUES(inven_quantity), inbound_date = VALUES(inbound_date), detail_inbound = VALUES(detail_inbound);

SET i = i + 1;
END WHILE;
END$$
DELIMITER ;
CALL sp_insert_partial_inbounds(61, 70);
DROP PROCEDURE sp_insert_partial_inbounds;

-- (71~100번) "대기/거절" (재고 X)
DELIMITER $$
CREATE PROCEDURE `sp_insert_pending_rejected`(IN start_id INT, IN end_id INT)
BEGIN
    DECLARE i INT DEFAULT start_id;
    DECLARE v_user_index BIGINT;
    DECLARE v_item_index BIGINT;
    DECLARE v_wh_index INT;
    DECLARE v_qty INT;
    DECLARE v_req_date DATETIME;
    DECLARE v_plan_date DATE;
    DECLARE v_status VARCHAR(20);

    SET @users = '1,2,6,10,11,15,21,26,31,34,36,39,44,46,49,54,56,59,64,66,70,74,76,84,93';

    WHILE i <= end_id DO
        SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (i % 25) + 1), ',', -1) AS UNSIGNED);
        SET v_item_index = (i % 25) + 1;
        SET v_wh_index = (i % 4) + 1;
        SET v_qty = 300;

        SET v_req_date = DATE_SUB('2025-09-20 14:00:00', INTERVAL (100-i) DAY);
        SET v_plan_date = DATE(DATE_ADD(v_req_date, INTERVAL 3 DAY));

        IF (i % 3) = 0 THEN SET v_status = 'PENDING';
        ELSEIF (i % 3) = 1 THEN SET v_status = 'REJECTED';
ELSE SET v_status = 'CANCELED';
END IF;

INSERT INTO inbound_request (inbound_request_quantity, inbound_request_date, planned_receive_date, approval_status, user_index, warehouse_index, item_index)
VALUES (v_qty, v_req_date, v_plan_date, v_status, v_user_index, v_wh_index, v_item_index);

SET i = i + 1;
END WHILE;
END$$
DELIMITER ;
CALL sp_insert_pending_rejected(71, 100);
DROP PROCEDURE sp_insert_pending_rejected;


-- =================================================================
-- 3. 출고 1200건 생성 (한달 치, 하루 평균 40건)
-- [수정됨] "과거" (v_day < 29)는 모두 DELIVERED / REJECTED 처리
-- [수정됨] "마지막 날" (v_day = 29)에만 모든 PENDING 상태 생성
-- =================================================================
DELIMITER $$
CREATE PROCEDURE `sp_generate_monthly_outbounds`()
BEGIN
    DECLARE v_day INT DEFAULT 0;
    DECLARE v_daily_requests INT;
    DECLARE j INT;

    DECLARE v_current_date DATETIME;
    DECLARE v_current_hour INT;
    DECLARE v_user_index BIGINT;
    DECLARE v_item_index BIGINT;
    DECLARE v_item_volume INT;
    DECLARE v_or_qty INT;
    DECLARE v_total_volume INT;
    DECLARE v_or_zip_code VARCHAR(10);
    DECLARE v_or_zip_prefix VARCHAR(2);
    DECLARE v_address VARCHAR(200);

    DECLARE v_inven_index BIGINT;
    DECLARE v_warehouse_index INT;
    DECLARE v_section_index BIGINT;
    DECLARE v_current_stock INT;

    DECLARE v_vehicle_index BIGINT;

    DECLARE v_or_index BIGINT;
    DECLARE v_dispatch_index BIGINT;
    DECLARE v_si_index BIGINT;

    DECLARE v_scenario_type DOUBLE;
    DECLARE v_completion_time DATETIME;

    SET @users = '1,2,6,10,11,15,21,26,31,34,36,39,44,46,49,54,56,59,64,66,70,74,76,84,93';
    SET @zipcodes = '06166,08393,16509,31226,01123,02345,03456,04567,05678,06789,07890,08901,09012,10123,11234,12345,13456,14567,15678,16789,17890,18901,31234,32345,33456';

    CREATE TEMPORARY TABLE IF NOT EXISTS temp_vehicle_capacity (
        vehicle_index BIGINT PRIMARY KEY,
        available_volume INT NOT NULL
    ) ENGINE=MEMORY;


    -- [LOOP 1: 30일 (한 달)]
    WHILE v_day < 30 DO

        SET v_daily_requests = 35 + FLOOR(RAND() * 11); -- 하루 35~45건
        SET j = 0;

        -- 매일 아침, 차량 용량 초기화
TRUNCATE TABLE temp_vehicle_capacity;
INSERT INTO temp_vehicle_capacity (vehicle_index, available_volume)
SELECT vehicle_index, vehicle_volume FROM Vehicle;

-- [LOOP 2: 하루 35~45건]
WHILE j < v_daily_requests DO

            -- 요청 시간 (24시간 동안 분배)
            SET v_current_date = DATE_ADD(DATE_ADD('2025-10-01 00:00:00', INTERVAL v_day DAY),
                                         INTERVAL (60*60*24 / v_daily_requests) * j SECOND);
            SET v_current_hour = HOUR(v_current_date);

            SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (v_day + j) % 25 + 1), ',', -1) AS UNSIGNED);
            SET v_item_index = (v_day + j) % 3 + 1;
            SET v_or_qty = 5 + FLOOR(RAND() * 30); -- 5~34개

SELECT item_volume INTO v_item_volume FROM items WHERE item_index = v_item_index;
SET v_total_volume = v_or_qty * v_item_volume;

            -- 재고 탐색
SELECT inven_index, warehouse_index, section_index, inven_quantity
INTO v_inven_index, v_warehouse_index, v_section_index, v_current_stock
FROM inventory
WHERE item_index = v_item_index AND inven_quantity > v_or_qty
ORDER BY inven_quantity DESC
    LIMIT 1;

-- 배송지 설정
SET v_or_zip_code = SUBSTRING_INDEX(SUBSTRING_INDEX(@zipcodes, ',', (j % 25) + 1), ',', -1);
            SET v_or_zip_prefix = LEFT(v_or_zip_code, 2);
            IF v_or_zip_prefix LIKE '0%' THEN SET v_address = '서울특별시';
            ELSEIF v_or_zip_prefix LIKE '1%' THEN SET v_address = '경기도';
ELSE SET v_address = '충청남도';
END IF;


            IF v_inven_index IS NULL THEN
                -- === (시나리오 F: 재고 부족 / REJECTED) ===
                INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, reject_detail, created_at, responded_at)
                VALUES (v_user_index, v_item_index, v_or_qty, '수령인F', '010-6666-6666', v_or_zip_code, v_address, '재고부족', 'REJECTED', 'PENDING', '출고 거절: 요청하신 상품의 재고가 부족합니다.', v_current_date, v_current_date);

            -- === [수정됨] "마지막 날" (v_day = 29) 에만 '대기' 상태 생성 ===
            ELSEIF v_day = 29 AND (v_current_hour >= 14 AND v_current_hour < 23) THEN
                -- === (시나리오 G: 운행 시간 마감 / PENDING) ===
                INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at)
                VALUES (v_user_index, v_item_index, v_or_qty, '수령인G', '010-7777-7777', v_or_zip_code, v_address, '운행시간', 'PENDING', 'PENDING', v_current_date);

ELSE
                -- (운행 가능 시간 OR 과거 데이터)

                -- [로직 4: 배차 탐색 (부피/지역/용량)]
SELECT v.vehicle_index INTO v_vehicle_index
FROM Vehicle v
         JOIN VehicleLocation vl ON v.vehicle_index = vl.vehicle_index
         JOIN temp_vehicle_capacity tvc ON v.vehicle_index = tvc.vehicle_index
WHERE vl.vl_zip_code = v_or_zip_prefix
  AND tvc.available_volume >= v_total_volume
ORDER BY tvc.available_volume ASC
    LIMIT 1;

SET v_scenario_type = RAND();

                -- === [수정됨] 과거 (v_day < 29)에는 REJECTED 또는 DELIVERED만 ===
                IF v_day < 29 AND v_vehicle_index IS NULL THEN
                     -- (과거) 배차 실패 -> 영구 거절 (다음날도 배차 못했다고 가정)
                    INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, reject_detail, created_at, responded_at)
                    VALUES (v_user_index, v_item_index, v_or_qty, '수령인B', '010-2222-2222', v_or_zip_code, v_address, '202호', 'REJECTED', 'PENDING',
                            CONCAT('배차 거절: 요청 부피(', v_total_volume, ') 또는 지역(', v_or_zip_prefix, ')을 처리할 가용 차량이 없습니다.'),
                            v_current_date, v_current_date);

                ELSEIF v_day < 29 AND v_vehicle_index IS NOT NULL THEN
                    -- (과거) 배차 성공 -> 무조건 DELIVERED
                    INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at, responded_at)
                    VALUES (v_user_index, v_item_index, v_or_qty, '수령인A', '010-1111-1111', v_or_zip_code, v_address, '101호', 'APPROVED', 'APPROVED', v_current_date, v_current_date);
                    SET v_or_index = LAST_INSERT_ID();

INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
VALUES (v_current_date, (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index), v_address, v_vehicle_index, v_or_index);
SET v_dispatch_index = LAST_INSERT_ID();

INSERT INTO ShippingInstruction (dispatch_index, admin_index, warehouse_index, section_index, si_waybill_status, approved_at)
VALUES (v_dispatch_index, 1, v_warehouse_index, v_section_index, 'APPROVED', v_current_date);
SET v_si_index = LAST_INSERT_ID();

UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index
WHERE inven_index = v_inven_index;

INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);

UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume
WHERE vehicle_index = v_vehicle_index;

SET v_completion_time = DATE_ADD(DATE(v_current_date), INTERVAL 14 + (j % 8) HOUR); -- 14:00 ~ 21:59

INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at, completed_at)
VALUES (CONCAT('CJ-E', 20000 + v_or_index), v_si_index, 'DELIVERED', v_current_date, v_completion_time);

-- === [수정됨] "마지막 날" (v_day = 29)에만 PENDING 분배 ===
ELSEIF v_day = 29 THEN

                    IF v_vehicle_index IS NULL THEN
                         -- (마지막 날) 배차 실패 -> PENDING (큐)
                        INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at)
                        VALUES (v_user_index, v_item_index, v_or_qty, '수령인B', '010-2222-2222', v_or_zip_code, v_address, '202호', 'PENDING', 'PENDING', v_current_date);

                    -- (마지막 날 + 배차 성공) -> 4가지 상태로 분배
                    ELSEIF v_scenario_type < 0.3 THEN -- (30%) DELIVERED
                        INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at, responded_at)
                        VALUES (v_user_index, v_item_index, v_or_qty, '수령인A', '010-1111-1111', v_or_zip_code, v_address, '101호', 'APPROVED', 'APPROVED', v_current_date, v_current_date);
                        SET v_or_index = LAST_INSERT_ID();
INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
VALUES (v_current_date, (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index), v_address, v_vehicle_index, v_or_index);
SET v_dispatch_index = LAST_INSERT_ID();
INSERT INTO ShippingInstruction (dispatch_index, admin_index, warehouse_index, section_index, si_waybill_status, approved_at)
VALUES (v_dispatch_index, 1, v_warehouse_index, v_section_index, 'APPROVED', v_current_date);
SET v_si_index = LAST_INSERT_ID();
UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index WHERE inven_index = v_inven_index;
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt) VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);
UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;
SET v_completion_time = DATE_ADD(DATE(v_current_date), INTERVAL 14 + (j % 8) HOUR);
INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at, completed_at)
VALUES (CONCAT('07', DATE_FORMAT(v_current_date, '%Y%m%d'), LPAD(v_si_index, 6, '0')), v_si_index, 'DELIVERED', v_current_date, v_completion_time);

ELSEIF v_scenario_type < 0.6 THEN -- (30%) IN_TRANSIT
                        INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at, responded_at)
                        VALUES (v_user_index, v_item_index, v_or_qty, '수령인A', '010-1111-1111', v_or_zip_code, v_address, '101호', 'APPROVED', 'APPROVED', v_current_date, v_current_date);
                        SET v_or_index = LAST_INSERT_ID();
INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
VALUES (v_current_date, (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index), v_address, v_vehicle_index, v_or_index);
SET v_dispatch_index = LAST_INSERT_ID();
INSERT INTO ShippingInstruction (dispatch_index, admin_index, warehouse_index, section_index, si_waybill_status, approved_at)
VALUES (v_dispatch_index, 1, v_warehouse_index, v_section_index, 'APPROVED', v_current_date);
SET v_si_index = LAST_INSERT_ID();
UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index WHERE inven_index = v_inven_index;
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt) VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);
UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;
INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at)
VALUES (CONCAT('CJ-A', 10000 + v_or_index), v_si_index, 'IN_TRANSIT', v_current_date);

ELSEIF v_scenario_type < 0.8 THEN -- (20%) PENDING_WAYBILL
                        INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at, responded_at)
                        VALUES (v_user_index, v_item_index, v_or_qty, '수령인H', '010-8888-8888', v_or_zip_code, v_address, '808호', 'APPROVED', 'APPROVED', v_current_date, v_current_date);
                        SET v_or_index = LAST_INSERT_ID();
INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
VALUES (v_current_date, (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index), v_address, v_vehicle_index, v_or_index);
SET v_dispatch_index = LAST_INSERT_ID();
INSERT INTO ShippingInstruction (dispatch_index, admin_index, warehouse_index, section_index, si_waybill_status, approved_at)
VALUES (v_dispatch_index, 1, v_warehouse_index, v_section_index, 'PENDING', v_current_date);
SET v_si_index = LAST_INSERT_ID();
UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index WHERE inven_index = v_inven_index;
INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt) VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);
UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;

ELSE -- (20%) PENDING_APPROVAL
                        INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at)
                        VALUES (v_user_index, v_item_index, v_or_qty, '수령인C', '010-3333-3333', v_or_zip_code, v_address, '303호', 'PENDING', 'APPROVED', v_current_date);
                        SET v_or_index = LAST_INSERT_ID();
INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
VALUES (v_current_date, (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index), v_address, v_vehicle_index, v_or_index);
UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;

END IF;
END IF; -- (v_day IF 종료)

END IF; -- (재고 IF 종료)

            SET v_inven_index = NULL; -- 루프 초기화
            SET v_vehicle_index = NULL; -- 루프 초기화
            SET j = j + 1;
END WHILE; -- 일일 루프

        SET v_day = v_day + 1;
END WHILE; -- 30일 루프

    DROP TEMPORARY TABLE IF EXISTS temp_vehicle_capacity;
END$$
DELIMITER ;

-- =================================================================
-- 4. 프로시저 실행 및 삭제
-- =================================================================
CALL sp_generate_monthly_outbounds();
DROP PROCEDURE sp_generate_monthly_outbounds;

-- =================================================================
-- 5. 최종 결과 확인
-- =================================================================

-- 1. 한달간의 출고 요청 상태 요약
-- [확인] 모든 PENDING 상태는 마지막 날(10월 30일)에만 존재해야 합니다.
SELECT
    DATE(o.created_at) AS 'Date',
    COUNT(*) AS 'Total Requests',
    SUM(CASE WHEN o.or_approval = 'APPROVED' AND w.waybill_status = 'DELIVERED' THEN 1 ELSE 0 END) AS 'Delivered',
    SUM(CASE WHEN o.or_approval = 'APPROVED' AND w.waybill_status = 'IN_TRANSIT' THEN 1 ELSE 0 END) AS 'In Transit',
    SUM(CASE WHEN o.or_approval = 'APPROVED' AND si.si_waybill_status = 'PENDING' THEN 1 ELSE 0 END) AS 'Pending Waybill',
    SUM(CASE WHEN o.or_approval = 'REJECTED' THEN 1 ELSE 0 END) AS 'Rejected',
    SUM(CASE WHEN o.or_approval = 'PENDING' AND o.or_dispatch_status = 'APPROVED' THEN 1 ELSE 0 END) AS 'Pending Approval',
    SUM(CASE WHEN o.or_approval = 'PENDING' AND o.or_dispatch_status = 'PENDING' THEN 1 ELSE 0 END) AS 'Pending Dispatch (Queue)'
FROM OutboundRequest o
    LEFT JOIN Dispatch d ON o.or_index = d.or_index
    LEFT JOIN ShippingInstruction si ON d.dispatch_index = si.dispatch_index
    LEFT JOIN Waybill w ON si.si_index = w.si_index
GROUP BY DATE(o.created_at)
ORDER BY DATE(o.created_at);

-- 2. 최종 재고 상태 (출고로 인해 차감된)
SELECT
    i.item_index,
    it.item_name,
    w.warehouse_name,
    s.section_name,
    i.inven_quantity AS 'Final Stock'
FROM inventory i
         JOIN items it ON i.item_index = it.item_index
         JOIN warehouse w ON i.warehouse_index = w.warehouse_index
         JOIN section s ON i.section_index = s.section_index
ORDER BY i.item_index, w.warehouse_name, s.section_name;

-- 3. 거절 사유 확인
SELECT reject_detail, COUNT(*) as count
FROM OutboundRequest
WHERE or_approval = 'REJECTED'
GROUP BY reject_detail;

-- 4. 배송 완료 시간 확인 (14:00 ~ 22:00 사이인지)
SELECT completed_at, HOUR(completed_at) AS 'Hour', COUNT(*) as count
FROM Waybill
WHERE completed_at IS NOT NULL
GROUP BY HOUR(completed_at)
ORDER BY HOUR(completed_at);