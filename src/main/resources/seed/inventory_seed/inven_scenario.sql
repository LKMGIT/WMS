USE wms;

-- ============================================================
-- 0. 모든 데이터 초기화
-- ============================================================
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

ALTER TABLE warehouse         AUTO_INCREMENT = 1;
ALTER TABLE section           AUTO_INCREMENT = 1;
ALTER TABLE items             AUTO_INCREMENT = 1;
ALTER TABLE Vehicle           AUTO_INCREMENT = 1;
ALTER TABLE VehicleLocation   AUTO_INCREMENT = 1;
ALTER TABLE inbound_request   AUTO_INCREMENT = 1;
ALTER TABLE inbound_detail    AUTO_INCREMENT = 1;
ALTER TABLE inventory         AUTO_INCREMENT = 1;
ALTER TABLE inven_count       AUTO_INCREMENT = 1;
ALTER TABLE OutboundRequest   AUTO_INCREMENT = 1;
ALTER TABLE Dispatch          AUTO_INCREMENT = 1;
ALTER TABLE ShippingInstruction AUTO_INCREMENT = 1;
ALTER TABLE Waybill           AUTO_INCREMENT = 1;

-- ============================================================
-- 1. 기본 마스터 데이터
-- ============================================================

-- 1-1. 창고
INSERT INTO warehouse(
    warehouse_code, warehouse_name, warehouse_size,
    warehouse_createdAt, warehouse_updatedAt,
    warehouse_location, warehouse_address, warehouse_zipcode, warehouse_status
)
VALUES
    (1, '강남창고', 1000, NOW(), NOW(), '서울특별시', '서울 강남구 삼성로 534', '06166', 'NORMAL'),
    (2, '구로창고', 2000, NOW(), NOW(), '서울특별시', '서울 구로구 디지털로26길 72', '08393', 'NORMAL'),
    (3, '수원창고', 3000, NOW(), NOW(), '경기',       '경기 수원시 영통구 광교중앙로 145', '16509', 'NORMAL'),
    (4, '천안창고', 1800, NOW(), NOW(), '충남',       '충남 천안시 동남구 목천읍 천안대로 2-10', '31226', 'NORMAL');

-- 1-2. 섹션
INSERT INTO section(section_code, section_name, section_capacity, warehouse_index)
VALUES
    (101, 'S-1', 333, 1), (102, 'S-2', 333, 1), (103, 'S-3', 334, 1),
    (201, 'S-1', 500, 2), (202, 'S-2', 500, 2), (203, 'S-3', 500, 2), (204, 'S-4', 500, 2),
    (301, 'S-1', 600, 3), (302, 'S-2', 600, 3), (303, 'S-3', 600, 3), (304, 'S-4', 600, 3), (305, 'S-5', 600, 3),
    (401, 'S-1', 450, 4), (402, 'S-2', 450, 4), (403, 'S-3', 450, 4), (404, 'S-4', 450, 4);

-- 1-3. 아이템
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

-- 1-4. 차량
INSERT INTO Vehicle (vehicle_name, vehicle_id, vehicle_volume, driver_name, driver_phone)
VALUES
    ('2.5톤 트럭 (서울 A)', '12가 1001', 100, '호날두', '010-1111-0001'),
    ('2.5톤 트럭 (서울 B)', '12가 1002', 100, '메시',   '010-1111-0002'),
    ('2.5톤 트럭 (서울 C)', '12가 1003', 100, '라모스', '010-1111-0003'),
    ('5톤 윙바디 (서울 D)', '12가 1004', 100, '베컴',   '010-1111-0004'),
    ('2.5톤 트럭 (서울 E)', '12가 1005', 100, '크로스', '010-1111-0005'),
    ('2.5톤 트럭 (경기 A)', '12가 1006', 100, '김덕배', '010-1111-0006'),
    ('2.5톤 트럭 (경기 B)', '12가 1007', 100, '콤파니', '010-1111-0007'),
    ('5톤 윙바디 (경기 C)', '12가 1008', 200, '밀리탕', '010-1111-0008'),
    ('2.5톤 트럭 (경기 D)', '12가 1009', 100, '음바페', '010-1111-0009'),
    ('2.5톤 트럭 (충남 A)', '12가 1010', 100, '알라바', '010-1111-0010'),
    ('2.5톤 트럭 (충남 B)', '12가 1011', 100, '손흥민', '010-1111-0011');

-- 1-5. 차량 위치 (우편번호 prefix용)
INSERT INTO VehicleLocation (vehicle_index, vl_zip_code)
VALUES
    (1, '01'), (1, '02'), (1, '03'),
    (2, '02'), (2, '03'), (2, '04'),
    (3, '04'), (3, '05'), (3, '06'),
    (4, '06'), (4, '07'), (4, '08'),
    (5, '08'), (5, '09'), (5, '01'),
    (6, '10'), (6, '11'), (6, '12'), (6, '13'),
    (7, '12'), (7, '13'), (7, '14'), (7, '15'),
    (8, '15'), (8, '16'), (8, '17'), (8, '18'),
    (9, '17'), (9, '18'), (9, '10'), (9, '11'),
    (10,'31'), (10,'32'),
    (11,'32'), (11,'33');

-- ============================================================
-- 2. 입고 생성 (2025-10-14 ~ 2025-11-14, 요일별로 들쑥날쑥)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_generate_inbounds_30days;
DELIMITER $$

CREATE PROCEDURE sp_generate_inbounds_30days()
BEGIN
    DECLARE v_day INT DEFAULT 0;
    DECLARE v_dow INT;
    DECLARE v_base_date DATETIME;

    DECLARE v_cnt_completed INT;
    DECLARE v_cnt_partial INT;
    DECLARE v_cnt_pending INT;

    DECLARE k INT;

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

    SET @users   = '1,2,6,10,11,15,21,26,31,34,36,39,44,46,49,54,56,59,64,66';
    SET @users2  = '70,74,76,84,93,101,102,103,104,105';

    WHILE v_day < 32 DO
            SET v_base_date = DATE_ADD('2025-10-14 09:00:00', INTERVAL v_day DAY);
            SET v_dow = DAYOFWEEK(DATE(v_base_date)); -- 1=일,7=토

            -- 요일별 입고 건수 (완전/부분/대기)
            IF v_dow IN (2,3,4) THEN             -- 월~수: 피크
                SET v_cnt_completed = 5 + FLOOR(RAND()*3);   -- 5~7
                SET v_cnt_partial   = 1 + FLOOR(RAND()*2);   -- 1~2
                SET v_cnt_pending   = FLOOR(RAND()*2);       -- 0~1
            ELSEIF v_dow IN (5,6) THEN           -- 목·금
                SET v_cnt_completed = 4 + FLOOR(RAND()*2);   -- 4~5
                SET v_cnt_partial   = FLOOR(RAND()*2);       -- 0~1
                SET v_cnt_pending   = 1 + FLOOR(RAND()*2);   -- 1~2
ELSE                                 -- 토·일
                SET v_cnt_completed = 2 + FLOOR(RAND()*2);   -- 2~3
                SET v_cnt_partial   = FLOOR(RAND()*2);       -- 0~1
                SET v_cnt_pending   = FLOOR(RAND()*2);       -- 0~1
END IF;

            -- -------------------------
            -- 2-1. 완전 입고 생성
            -- -------------------------
            SET k = 0;
            WHILE k < v_cnt_completed DO
                    SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (v_day + k) % 20 + 1), ',', -1) AS UNSIGNED);
                    SET v_item_index = (v_day + k) % 3 + 1;
                    SET v_wh_index   = (v_day + k) % 4 + 1;

SELECT section_index, section_code
INTO v_sec_index_pk, v_sec_code
FROM section
WHERE warehouse_index = v_wh_index
ORDER BY RAND()
    LIMIT 1;

-- 수량: 220~420 정도
SET v_recv_qty = 220 + (v_day % 5) * 20 + (k % 4) * 15;

                    SET v_req_date     = DATE_ADD(v_base_date,    INTERVAL (k*60) MINUTE);
                    SET v_plan_date    = DATE(DATE_ADD(v_req_date,   INTERVAL 3 DAY));
                    SET v_approve_date = DATE_ADD(v_req_date,        INTERVAL 1 DAY);
                    SET v_complete_date= DATE_ADD(v_approve_date,    INTERVAL 2 DAY);

INSERT INTO inbound_request (
    inbound_request_quantity, inbound_request_date, planned_receive_date,
    approval_status, approve_date, user_index, warehouse_index, item_index
) VALUES (
             v_recv_qty, v_req_date, v_plan_date,
             'APPROVED', v_approve_date,
             v_user_index, v_wh_index, v_item_index
         );

SET v_inbound_idx = LAST_INSERT_ID();

INSERT INTO inbound_detail (
    inbound_index, received_quantity, complete_date,
    warehouse_index, section_index
) VALUES (
             v_inbound_idx, v_recv_qty, v_complete_date,
             v_wh_index, CAST(v_sec_code AS CHAR)
         );

INSERT INTO inventory (
    item_index, warehouse_index, section_index,
    inven_quantity, inbound_date, detail_inbound
) VALUES (
             v_item_index, v_wh_index, v_sec_index_pk,
             v_recv_qty, v_complete_date, v_inbound_idx
         )
    ON DUPLICATE KEY UPDATE
                         inven_quantity = inven_quantity + VALUES(inven_quantity),
                         inbound_date   = VALUES(inbound_date),
                         detail_inbound = VALUES(detail_inbound);

SET k = k + 1;
END WHILE;

            -- -------------------------
            -- 2-2. 부분 입고 생성
            -- -------------------------
            SET k = 0;
            WHILE k < v_cnt_partial DO
                    SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (v_day + k + 5) % 20 + 1), ',', -1) AS UNSIGNED);
                    SET v_item_index = (v_day + k + 7) % 3 + 1;
                    SET v_wh_index   = (v_day + k + 3) % 4 + 1;

SELECT section_index, section_code
INTO v_sec_index_pk, v_sec_code
FROM section
WHERE warehouse_index = v_wh_index
ORDER BY RAND()
    LIMIT 1;

SET v_req_qty  = 500 + (v_day % 4) * 40;   -- 요청량
                    SET v_recv_qty = 260 + (k % 3) * 40;       -- 실제 입고량

                    IF v_recv_qty >= v_req_qty THEN
                        SET v_recv_qty = v_req_qty - 100;
END IF;

                    SET v_req_date      = DATE_ADD(v_base_date,    INTERVAL (k*75 + 15) MINUTE);
                    SET v_plan_date     = DATE(DATE_ADD(v_req_date,    INTERVAL 4 DAY));
                    SET v_approve_date  = DATE_ADD(v_req_date,        INTERVAL 1 DAY);
                    SET v_complete_date = DATE_ADD(v_approve_date,    INTERVAL 3 DAY);

INSERT INTO inbound_request (
    inbound_request_quantity, inbound_request_date, planned_receive_date,
    approval_status, approve_date, user_index, warehouse_index, item_index
) VALUES (
             v_req_qty, v_req_date, v_plan_date,
             'APPROVED', v_approve_date,
             v_user_index, v_wh_index, v_item_index
         );

SET v_inbound_idx = LAST_INSERT_ID();

INSERT INTO inbound_detail (
    inbound_index, received_quantity, complete_date,
    warehouse_index, section_index
) VALUES (
             v_inbound_idx, v_recv_qty, v_complete_date,
             v_wh_index, CAST(v_sec_code AS CHAR)
         );

INSERT INTO inventory (
    item_index, warehouse_index, section_index,
    inven_quantity, inbound_date, detail_inbound
) VALUES (
             v_item_index, v_wh_index, v_sec_index_pk,
             v_recv_qty, v_complete_date, v_inbound_idx
         )
    ON DUPLICATE KEY UPDATE
                         inven_quantity = inven_quantity + VALUES(inven_quantity),
                         inbound_date   = VALUES(inbound_date),
                         detail_inbound = VALUES(detail_inbound);

SET k = k + 1;
END WHILE;

            -- -------------------------
            -- 2-3. 대기/거절 입고 (재고 반영 X)
            -- -------------------------
            SET k = 0;
            WHILE k < v_cnt_pending DO
                    SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users2, ',', (v_day + k) % 10 + 1), ',', -1) AS UNSIGNED);
                    SET v_item_index = (v_day + k + 11) % 3 + 1;
                    SET v_wh_index   = (v_day + k + 5) % 4 + 1;

                    SET v_req_qty  = 400 + (k % 3) * 50;
                    SET v_req_date = DATE_ADD(v_base_date, INTERVAL (k*45 + 30) MINUTE);
                    SET v_plan_date = DATE(DATE_ADD(v_req_date, INTERVAL 5 DAY));

                    IF (k % 3) = 0 THEN
                        INSERT INTO inbound_request (
                            inbound_request_quantity, inbound_request_date, planned_receive_date,
                            approval_status, user_index, warehouse_index, item_index
                        ) VALUES (
                                     v_req_qty, v_req_date, v_plan_date,
                                     'PENDING', v_user_index, v_wh_index, v_item_index
                                 );
                    ELSEIF (k % 3) = 1 THEN
                        INSERT INTO inbound_request (
                            inbound_request_quantity, inbound_request_date, planned_receive_date,
                            approval_status, user_index, warehouse_index, item_index
                        ) VALUES (
                                     v_req_qty, v_req_date, v_plan_date,
                                     'REJECTED', v_user_index, v_wh_index, v_item_index
                                 );
ELSE
                        INSERT INTO inbound_request (
                            inbound_request_quantity, inbound_request_date, planned_receive_date,
                            approval_status, user_index, warehouse_index, item_index
                        ) VALUES (
                                     v_req_qty, v_req_date, v_plan_date,
                                     'CANCELED', v_user_index, v_wh_index, v_item_index
                                 );
END IF;

                    SET k = k + 1;
END WHILE;

            SET v_day = v_day + 1;
END WHILE;
END$$
DELIMITER ;

CALL sp_generate_inbounds_30days();
DROP PROCEDURE sp_generate_inbounds_30days;

-- ============================================================
-- 3. 출고 생성 (2025-10-14 ~ 2025-11-14, 하루 12~21건)
--      - v_day < 31 : DELIVERED/REJECTED만
--      - v_day = 31 : PENDING 상태들 섞기
-- ============================================================
DROP PROCEDURE IF EXISTS sp_generate_monthly_outbounds;
DELIMITER $$

CREATE PROCEDURE sp_generate_monthly_outbounds()
BEGIN
    DECLARE v_day INT DEFAULT 0;
    DECLARE v_daily_requests INT;
    DECLARE j INT;

    DECLARE v_current_date DATETIME;
    DECLARE v_current_hour INT;
    DECLARE v_dow INT;

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

    WHILE v_day < 32 DO
            SET v_current_date = DATE_ADD('2025-10-14 00:00:00', INTERVAL v_day DAY);
            SET v_dow = DAYOFWEEK(DATE(v_current_date));

            -- 요일별 출고 요청 수 (건수 자체를 줄여서 그래프 간격 완화)
            IF v_dow IN (2,3,4) THEN          -- 월~수
                SET v_daily_requests = 16 + FLOOR(RAND()*6);  -- 16~21건
            ELSEIF v_dow IN (5,6) THEN        -- 목·금
                SET v_daily_requests = 13 + FLOOR(RAND()*6);  -- 13~18건
ELSE                              -- 토·일
                SET v_daily_requests = 8  + FLOOR(RAND()*6);  -- 8~13건
END IF;

            SET j = 0;

TRUNCATE TABLE temp_vehicle_capacity;
INSERT INTO temp_vehicle_capacity (vehicle_index, available_volume)
SELECT vehicle_index, vehicle_volume FROM Vehicle;

WHILE j < v_daily_requests DO
                    -- 하루 동안 시간 분배
                    SET v_current_date = DATE_ADD(
                            DATE_ADD('2025-10-14 00:00:00', INTERVAL v_day DAY),
                            INTERVAL (86400 / v_daily_requests) * j SECOND
                                         );
                    SET v_current_hour = HOUR(v_current_date);

                    SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (v_day + j) % 25 + 1), ',', -1) AS UNSIGNED);
                    SET v_item_index = (v_day + j) % 3 + 1;

                    -- 주문 수량: 3~10개
                    SET v_or_qty = 3 + FLOOR(RAND() * 8);

SELECT item_volume INTO v_item_volume
FROM items
WHERE item_index = v_item_index;

SET v_total_volume = v_or_qty * v_item_volume;

                    -- 재고 탐색
SELECT inven_index, warehouse_index, section_index, inven_quantity
INTO v_inven_index, v_warehouse_index, v_section_index, v_current_stock
FROM inventory
WHERE item_index = v_item_index
  AND inven_quantity > v_or_qty
ORDER BY inven_quantity DESC
    LIMIT 1;

-- 배송지 (우편번호 prefix로 지역 구분)
SET v_or_zip_code  = SUBSTRING_INDEX(SUBSTRING_INDEX(@zipcodes, ',', (j % 25) + 1), ',', -1);
                    SET v_or_zip_prefix = LEFT(v_or_zip_code, 2);

                    IF v_or_zip_prefix LIKE '0%' THEN
                        SET v_address = '서울특별시';
                    ELSEIF v_or_zip_prefix LIKE '1%' THEN
                        SET v_address = '경기도';
ELSE
                        SET v_address = '충청남도';
END IF;

                    IF v_inven_index IS NULL THEN
                        -- 재고 부족 → REJECTED
                        INSERT INTO OutboundRequest (
                            user_index, item_index, or_quantity,
                            or_name, or_phone,
                            or_zip_code, or_street_address, or_detailed_address,
                            or_approval, or_dispatch_status, reject_detail,
                            created_at, responded_at
                        ) VALUES (
                                     v_user_index, v_item_index, v_or_qty,
                                     '수령인F', '010-6666-6666',
                                     v_or_zip_code, v_address, '재고부족',
                                     'REJECTED', 'PENDING',
                                     '출고 거절: 요청하신 상품의 재고가 부족합니다.',
                                     v_current_date, v_current_date
                                 );
ELSE
                        -- 배차 가능한 차량 탐색
SELECT v.vehicle_index
INTO v_vehicle_index
FROM Vehicle v
         JOIN VehicleLocation vl  ON v.vehicle_index = vl.vehicle_index
         JOIN temp_vehicle_capacity tvc ON v.vehicle_index = tvc.vehicle_index
WHERE vl.vl_zip_code = v_or_zip_prefix
  AND tvc.available_volume >= v_total_volume
ORDER BY tvc.available_volume ASC
    LIMIT 1;

SET v_scenario_type = RAND();

                        IF v_day < 31 THEN
                            -- 과거 날짜: 배차 실패 시 REJECTED, 성공 시 무조건 DELIVERED
                            IF v_vehicle_index IS NULL THEN
                                INSERT INTO OutboundRequest (
                                    user_index, item_index, or_quantity,
                                    or_name, or_phone,
                                    or_zip_code, or_street_address, or_detailed_address,
                                    or_approval, or_dispatch_status, reject_detail,
                                    created_at, responded_at
                                ) VALUES (
                                             v_user_index, v_item_index, v_or_qty,
                                             '수령인B', '010-2222-2222',
                                             v_or_zip_code, v_address, '202호',
                                             'REJECTED', 'PENDING',
                                             CONCAT('배차 거절: 요청 부피(', v_total_volume, ') 또는 지역(', v_or_zip_prefix, ')을 처리할 가용 차량이 없습니다.'),
                                             v_current_date, v_current_date
                                         );
ELSE
                                INSERT INTO OutboundRequest (
                                    user_index, item_index, or_quantity,
                                    or_name, or_phone,
                                    or_zip_code, or_street_address, or_detailed_address,
                                    or_approval, or_dispatch_status,
                                    created_at, responded_at
                                ) VALUES (
                                             v_user_index, v_item_index, v_or_qty,
                                             '수령인A', '010-1111-1111',
                                             v_or_zip_code, v_address, '101호',
                                             'APPROVED', 'APPROVED',
                                             v_current_date, v_current_date
                                         );
                                SET v_or_index = LAST_INSERT_ID();

INSERT INTO Dispatch (
    dispatch_date, start_point, end_point,
    vehicle_index, or_index
) VALUES (
             v_current_date,
             (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index),
             v_address, v_vehicle_index, v_or_index
         );
SET v_dispatch_index = LAST_INSERT_ID();

INSERT INTO ShippingInstruction (
    dispatch_index, admin_index,
    warehouse_index, section_index,
    si_waybill_status, approved_at
) VALUES (
             v_dispatch_index, 1,
             v_warehouse_index, v_section_index,
             'APPROVED', v_current_date
         );
SET v_si_index = LAST_INSERT_ID();

UPDATE inventory
SET inven_quantity = inven_quantity - v_or_qty,
    shipping_date  = v_current_date,
    detail_outbound = v_or_index
WHERE inven_index = v_inven_index;

INSERT INTO inven_count (
    inven_index, inven_quantity, actual_quantity, count_updateAt
) VALUES (
             v_inven_index,
             v_current_stock,
             v_current_stock - v_or_qty,
             v_current_date
         );

UPDATE temp_vehicle_capacity
SET available_volume = available_volume - v_total_volume
WHERE vehicle_index = v_vehicle_index;

SET v_completion_time = DATE_ADD(
                                        DATE(v_current_date),
                                        INTERVAL 14 + (j % 8) HOUR
                                                        );

INSERT INTO Waybill (
    waybill_id, si_index, waybill_status,
    created_at, completed_at
) VALUES (
             CONCAT('CJ-E', 20000 + v_or_index),
             v_si_index, 'DELIVERED',
             v_current_date, v_completion_time
         );
END IF;
ELSE
                            -- 마지막 날짜(2025-11-14): PENDING/IN_TRANSIT 등 섞기
                            IF v_vehicle_index IS NULL THEN
                                -- 큐 대기
                                INSERT INTO OutboundRequest (
                                    user_index, item_index, or_quantity,
                                    or_name, or_phone,
                                    or_zip_code, or_street_address, or_detailed_address,
                                    or_approval, or_dispatch_status,
                                    created_at
                                ) VALUES (
                                             v_user_index, v_item_index, v_or_qty,
                                             '수령인B', '010-2222-2222',
                                             v_or_zip_code, v_address, '202호',
                                             'PENDING', 'PENDING',
                                             v_current_date
                                         );
                            ELSEIF v_scenario_type < 0.35 THEN
                                -- 35% DELIVERED
                                INSERT INTO OutboundRequest (
                                    user_index, item_index, or_quantity,
                                    or_name, or_phone,
                                    or_zip_code, or_street_address, or_detailed_address,
                                    or_approval, or_dispatch_status,
                                    created_at, responded_at
                                ) VALUES (
                                             v_user_index, v_item_index, v_or_qty,
                                             '수령인A', '010-1111-1111',
                                             v_or_zip_code, v_address, '101호',
                                             'APPROVED', 'APPROVED',
                                             v_current_date, v_current_date
                                         );
                                SET v_or_index = LAST_INSERT_ID();

INSERT INTO Dispatch (
    dispatch_date, start_point, end_point,
    vehicle_index, or_index
) VALUES (
             v_current_date,
             (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index),
             v_address, v_vehicle_index, v_or_index
         );
SET v_dispatch_index = LAST_INSERT_ID();

INSERT INTO ShippingInstruction (
    dispatch_index, admin_index,
    warehouse_index, section_index,
    si_waybill_status, approved_at
) VALUES (
             v_dispatch_index, 1,
             v_warehouse_index, v_section_index,
             'APPROVED', v_current_date
         );
SET v_si_index = LAST_INSERT_ID();

UPDATE inventory
SET inven_quantity = inven_quantity - v_or_qty,
    shipping_date  = v_current_date,
    detail_outbound = v_or_index
WHERE inven_index = v_inven_index;

INSERT INTO inven_count (
    inven_index, inven_quantity, actual_quantity, count_updateAt
) VALUES (
             v_inven_index,
             v_current_stock,
             v_current_stock - v_or_qty,
             v_current_date
         );

UPDATE temp_vehicle_capacity
SET available_volume = available_volume - v_total_volume
WHERE vehicle_index = v_vehicle_index;

SET v_completion_time = DATE_ADD(
                                        DATE(v_current_date),
                                        INTERVAL 14 + (j % 8) HOUR
                                                        );

INSERT INTO Waybill (
    waybill_id, si_index, waybill_status,
    created_at, completed_at
) VALUES (
             CONCAT('07', DATE_FORMAT(v_current_date,'%Y%m%d'), LPAD(v_si_index,6,'0')),
             v_si_index, 'DELIVERED',
             v_current_date, v_completion_time
         );
ELSEIF v_scenario_type < 0.6 THEN
                                -- 25% IN_TRANSIT
                                INSERT INTO OutboundRequest (
                                    user_index, item_index, or_quantity,
                                    or_name, or_phone,
                                    or_zip_code, or_street_address, or_detailed_address,
                                    or_approval, or_dispatch_status,
                                    created_at, responded_at
                                ) VALUES (
                                             v_user_index, v_item_index, v_or_qty,
                                             '수령인A', '010-1111-1111',
                                             v_or_zip_code, v_address, '101호',
                                             'APPROVED', 'APPROVED',
                                             v_current_date, v_current_date
                                         );
                                SET v_or_index = LAST_INSERT_ID();

INSERT INTO Dispatch (
    dispatch_date, start_point, end_point,
    vehicle_index, or_index
) VALUES (
             v_current_date,
             (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index),
             v_address, v_vehicle_index, v_or_index
         );
SET v_dispatch_index = LAST_INSERT_ID();

INSERT INTO ShippingInstruction (
    dispatch_index, admin_index,
    warehouse_index, section_index,
    si_waybill_status, approved_at
) VALUES (
             v_dispatch_index, 1,
             v_warehouse_index, v_section_index,
             'APPROVED', v_current_date
         );
SET v_si_index = LAST_INSERT_ID();

UPDATE inventory
SET inven_quantity = inven_quantity - v_or_qty,
    shipping_date  = v_current_date,
    detail_outbound = v_or_index
WHERE inven_index = v_inven_index;

INSERT INTO inven_count (
    inven_index, inven_quantity, actual_quantity, count_updateAt
) VALUES (
             v_inven_index,
             v_current_stock,
             v_current_stock - v_or_qty,
             v_current_date
         );

UPDATE temp_vehicle_capacity
SET available_volume = available_volume - v_total_volume
WHERE vehicle_index = v_vehicle_index;

INSERT INTO Waybill (
    waybill_id, si_index, waybill_status,
    created_at
) VALUES (
             CONCAT('CJ-A', 10000 + v_or_index),
             v_si_index, 'IN_TRANSIT',
             v_current_date
         );
ELSEIF v_scenario_type < 0.8 THEN
                                -- 20% PENDING_WAYBILL (출고까지 나갔지만 운송장 미발행)
                                INSERT INTO OutboundRequest (
                                    user_index, item_index, or_quantity,
                                    or_name, or_phone,
                                    or_zip_code, or_street_address, or_detailed_address,
                                    or_approval, or_dispatch_status,
                                    created_at, responded_at
                                ) VALUES (
                                             v_user_index, v_item_index, v_or_qty,
                                             '수령인H', '010-8888-8888',
                                             v_or_zip_code, v_address, '808호',
                                             'APPROVED', 'APPROVED',
                                             v_current_date, v_current_date
                                         );
                                SET v_or_index = LAST_INSERT_ID();

INSERT INTO Dispatch (
    dispatch_date, start_point, end_point,
    vehicle_index, or_index
) VALUES (
             v_current_date,
             (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index),
             v_address, v_vehicle_index, v_or_index
         );
SET v_dispatch_index = LAST_INSERT_ID();

INSERT INTO ShippingInstruction (
    dispatch_index, admin_index,
    warehouse_index, section_index,
    si_waybill_status, approved_at
) VALUES (
             v_dispatch_index, 1,
             v_warehouse_index, v_section_index,
             'PENDING', v_current_date
         );
SET v_si_index = LAST_INSERT_ID();

UPDATE inventory
SET inven_quantity = inven_quantity - v_or_qty,
    shipping_date  = v_current_date,
    detail_outbound = v_or_index
WHERE inven_index = v_inven_index;

INSERT INTO inven_count (
    inven_index, inven_quantity, actual_quantity, count_updateAt
) VALUES (
             v_inven_index,
             v_current_stock,
             v_current_stock - v_or_qty,
             v_current_date
         );

UPDATE temp_vehicle_capacity
SET available_volume = available_volume - v_total_volume
WHERE vehicle_index = v_vehicle_index;
ELSE
                                -- 20% PENDING_APPROVAL (운영 승인 대기)
                                INSERT INTO OutboundRequest (
                                    user_index, item_index, or_quantity,
                                    or_name, or_phone,
                                    or_zip_code, or_street_address, or_detailed_address,
                                    or_approval, or_dispatch_status,
                                    created_at
                                ) VALUES (
                                             v_user_index, v_item_index, v_or_qty,
                                             '수령인C', '010-3333-3333',
                                             v_or_zip_code, v_address, '303호',
                                             'PENDING', 'APPROVED',
                                             v_current_date
                                         );
                                SET v_or_index = LAST_INSERT_ID();

INSERT INTO Dispatch (
    dispatch_date, start_point, end_point,
    vehicle_index, or_index
) VALUES (
             v_current_date,
             (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index),
             v_address, v_vehicle_index, v_or_index
         );

UPDATE temp_vehicle_capacity
SET available_volume = available_volume - v_total_volume
WHERE vehicle_index = v_vehicle_index;
END IF;
END IF;
END IF; -- 재고 유무

                    SET v_inven_index = NULL;
                    SET v_vehicle_index = NULL;
                    SET j = j + 1;
END WHILE;

            SET v_day = v_day + 1;
END WHILE;

    DROP TEMPORARY TABLE IF EXISTS temp_vehicle_capacity;
END$$
DELIMITER ;

CALL sp_generate_monthly_outbounds();
DROP PROCEDURE sp_generate_monthly_outbounds;

-- ============================================================
-- 4. 확인용 쿼리 (그래프 점검)
-- ============================================================

-- (1) OutboundRequest / Waybill 기간 확인
SELECT MIN(created_at) AS min_or, MAX(created_at) AS max_or
FROM OutboundRequest;
SELECT MIN(created_at) AS min_wb, MAX(created_at) AS max_wb
FROM Waybill;
SELECT MIN(completed_at) AS min_completed, MAX(completed_at) AS max_completed
FROM Waybill;

-- (2) 최근 30일 입고/출고 "건수" (지금 대시보드와 동일한 기준)
SELECT DATE(id.complete_date) AS d, COUNT(*) AS inbound_cnt
FROM inbound_detail id
WHERE id.complete_date BETWEEN '2025-10-14' AND '2025-11-14'
GROUP BY DATE(id.complete_date)
ORDER BY d;

SELECT DATE(o.created_at) AS d, COUNT(*) AS outbound_cnt
FROM OutboundRequest o
WHERE o.created_at BETWEEN '2025-10-14' AND '2025-11-14'
GROUP BY DATE(o.created_at)
ORDER BY d;

-- (3) (옵션) 수량 기준 그래프를 쓰고 싶을 때는 SUM으로 변경
-- SELECT DATE(id.complete_date) AS d, SUM(id.received_quantity) AS inbound_qty ...
-- SELECT DATE(o.created_at) AS d, SUM(o.or_quantity)        AS outbound_qty ...
