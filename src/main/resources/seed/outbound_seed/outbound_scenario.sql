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
-- 1. 기본 데이터 생성 (창고, 섹션, 아이템, 차량)
-- =================================================================
-- 1-1. 창고 (Warehouse)
INSERT INTO warehouse (warehouse_index, warehouse_code, warehouse_name, warehouse_size, warehouse_location, warehouse_address, warehouse_zipcode, warehouse_status)
VALUES
    (1, 1001, '서울 A 센터', 5000, '서울', '서울특별시 강남구', '01', 'NORMAL'),
    (2, 1002, '서울 B 센터', 3000, '서울', '서울특별시 마포구', '03', 'NORMAL'),
    (3, 2001, '경기 센터', 10000, '경기', '경기도 용인시', '10', 'NORMAL'),
    (4, 3001, '충남 센터', 8000, '충남', '충청남도 천안시', '31', 'NORMAL');

-- 1-2. 섹션 (Section)
INSERT INTO section (section_code, section_name, section_capacity, warehouse_index)
VALUES
    (100101, 'A-01-01 (상온)', 5000, 1), -- 서울 A 센터
    (100201, 'B-01-01 (항온)', 3000, 2), -- 서울 B 센터
    (200101, 'C-01-01 (상온)', 10000, 3), -- 경기 센터
    (300101, 'D-01-01 (상온)', 8000, 4); -- 충남 센터

-- 1-3. 아이템 (Items) - (inbound_index 컬럼은 NOT NULL 제약에도 불구하고 논리적 오류로 판단, 제외함)
INSERT INTO items (item_name, item_price, item_volume, item_category)
VALUES
    ('(A) 핸드크림 50ml', 5000, 1, 'BEAUTY'),
    ('(B) 대용량 샴푸 1L', 15000, 3, 'CARE'),
    ('(C) 수딩 토너 200ml', 12000, 2, 'BEAUTY');

-- 1-4. 차량 (Vehicle)
INSERT INTO Vehicle (vehicle_name, vehicle_id, vehicle_volume, driver_name, driver_phone)
VALUES
    ('1톤 트럭 (서울 A)', '12가 1001', 30, '호날두','010-1111-0001'),
    ('2.5톤 트럭 (서울 B)', '12가 1002', 75, '메시', '010-1111-0002' ),
    ('5톤 윙바디 (서울 C)', '12가 1004', 150, '베컴', '010-1111-0004'),
    ('2.5톤 트럭 (경기 A)', '12가 1006', 75, '김덕배', '010-1111-0006'),
    ('5톤 윙바디 (경기 B)', '12가 1008', 150,  '밀리탕', '010-1111-0008'),
    ('2.5톤 트럭 (충남 A)', '12가 1010', 75, '알라바','010-1111-0010');

-- 1-5. 차량 위치 (VehicleLocation) - (zipcode 2자리)
INSERT INTO VehicleLocation (vehicle_index, vl_zip_code)
VALUES
    (1, '01'), (1, '02'), -- 1톤 서울A (v_index 1)
    (2, '03'), (2, '04'), -- 2.5톤 서울B (v_index 2)
    (3, '01'), (3, '03'), (3, '05'), -- 5톤 서울C (v_index 3)
    (4, '10'), (4, '11'), (4, '12'), -- 2.5톤 경기A (v_index 4)
    (5, '10'), (5, '13'), (5, '14'), -- 5톤 경기B (v_index 5)
    (6, '31'), (6, '32'); -- 2.5톤 충남A (v_index 6)


-- =================================================================
-- 2. 입고 100건 생성 (재고 확보)
-- (총 70건의 재고가 Inventory에 적재됨)
-- =================================================================

-- (1~60번) "완전 입고" 프로시저 (대량 재고 확보)
DELIMITER $$
CREATE PROCEDURE `sp_insert_completed_inbounds`(IN start_id INT, IN end_id INT)
BEGIN
    DECLARE i INT DEFAULT start_id;
    DECLARE v_user_index BIGINT;
    DECLARE v_item_index BIGINT;
    DECLARE v_wh_index INT;
    DECLARE v_sec_index_pk BIGINT; -- inventory용 (BIGINT)
    DECLARE v_sec_code VARCHAR(100); -- inbound_detail용 (VARCHAR)
    DECLARE v_qty INT;
    DECLARE v_req_date DATETIME;
    DECLARE v_plan_date DATE;
    DECLARE v_approve_date DATETIME;
    DECLARE v_complete_date DATETIME;
    DECLARE v_inbound_idx BIGINT;

    SET @users = '1,2,6,10,11,15,21,26,31,34,36,39,44,46,49,54,56,59,64,66';
    SET @items = '1,2,3';

    WHILE i <= end_id DO
        SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (i % 20) + 1), ',', -1) AS UNSIGNED);
        SET v_item_index = (i % 3) + 1;
        SET v_wh_index = (i % 4) + 1;

        -- WH 1->Sec 1, WH 2->Sec 2 ...
SELECT section_index, section_code INTO v_sec_index_pk, v_sec_code
FROM section WHERE warehouse_index = v_wh_index LIMIT 1;

SET v_qty = ((i % 5) + 2) * 1000; -- 2000, 3000, 4000, 5000, 6000 (대량)

        SET v_req_date = DATE_SUB('2025-09-01 10:00:00', INTERVAL (60-i) DAY);
        SET v_plan_date = DATE(DATE_ADD(v_req_date, INTERVAL 3 DAY));
        SET v_approve_date = DATE_ADD(v_req_date, INTERVAL 1 DAY);
        SET v_complete_date = DATE_ADD(v_approve_date, INTERVAL 3 DAY);

INSERT INTO inbound_request (inbound_request_quantity, inbound_request_date, planned_receive_date, approval_status, approve_date, user_index, warehouse_index, item_index)
VALUES (v_qty, v_req_date, v_plan_date, 'APPROVED', v_approve_date, v_user_index, v_wh_index, v_item_index);

SET v_inbound_idx = LAST_INSERT_ID();

        -- inbound_detail.section_index (VARCHAR) 에는 section_code('100101') 저장
INSERT INTO inbound_detail (inbound_index, received_quantity, complete_date, warehouse_index, section_index)
VALUES (v_inbound_idx, v_qty, v_complete_date, v_wh_index, v_sec_code);

-- inventory.section_index (BIGINT) 에는 section_index(1) 저장
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
    DECLARE v_sec_code VARCHAR(100);
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
        SET v_item_index = (i % 3) + 1;
        SET v_wh_index = (i % 4) + 1;

SELECT section_index, section_code INTO v_sec_index_pk, v_sec_code
FROM section WHERE warehouse_index = v_wh_index LIMIT 1;

SET v_req_qty = 5000;
        SET v_recv_qty = 1000;

        SET v_req_date = DATE_SUB('2025-09-15 11:00:00', INTERVAL (70-i) DAY);
        SET v_plan_date = DATE(DATE_ADD(v_req_date, INTERVAL 3 DAY));
        SET v_approve_date = DATE_ADD(v_req_date, INTERVAL 1 DAY);
        SET v_complete_date = DATE_ADD(v_approve_date, INTERVAL 3 DAY);

INSERT INTO inbound_request (inbound_request_quantity, inbound_request_date, planned_receive_date, approval_status, approve_date, user_index, warehouse_index, item_index)
VALUES (v_req_qty, v_req_date, v_plan_date, 'APPROVED', v_approve_date, v_user_index, v_wh_index, v_item_index);

SET v_inbound_idx = LAST_INSERT_ID();

INSERT INTO inbound_detail (inbound_index, received_quantity, complete_date, warehouse_index, section_index)
VALUES (v_inbound_idx, v_recv_qty, v_complete_date, v_wh_index, v_sec_code);

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
        SET v_item_index = (i % 3) + 1;
        SET v_wh_index = (i % 4) + 1;
        SET v_qty = 1000;

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
-- =================================================================
DELIMITER $$
CREATE PROCEDURE `sp_generate_monthly_outbounds`()
BEGIN
    DECLARE v_day INT DEFAULT 0;
    DECLARE v_daily_requests INT;
    DECLARE j INT;

    DECLARE v_current_date DATETIME;
    DECLARE v_user_index BIGINT;
    DECLARE v_item_index BIGINT;
    DECLARE v_item_volume INT;
    DECLARE v_or_qty INT;
    DECLARE v_total_volume INT;
    DECLARE v_zip_code VARCHAR(2);
    DECLARE v_warehouse_name VARCHAR(100);
    DECLARE v_address VARCHAR(200);

    -- 재고 조회용
    DECLARE v_inven_index BIGINT;
    DECLARE v_warehouse_index INT;
    DECLARE v_section_index BIGINT;
    DECLARE v_current_stock INT;

    -- 배차 조회용
    DECLARE v_vehicle_index BIGINT;

    -- PK/FK 저장용
    DECLARE v_or_index BIGINT;
    DECLARE v_dispatch_index BIGINT;
    DECLARE v_si_index BIGINT;

    DECLARE v_scenario_type DOUBLE;

    SET @users = '1,2,6,10,11,15,21,26,31,34,36,39,44,46,49,54,56,59,64,66,70,74,76,84,93';
    SET @items = '1,2,3';

    -- [LOOP 1: 30일 (한 달)]
    WHILE v_day < 30 DO
        SET v_current_date = DATE_ADD('2025-10-01 09:00:00', INTERVAL v_day DAY);
        SET v_daily_requests = 35 + FLOOR(RAND() * 11); -- 하루 35~45건
        SET j = 0;

        -- [LOOP 2: 하루 35~45건]
        WHILE j < v_daily_requests DO

            -- 기본 요청 정보 생성
            SET v_user_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@users, ',', (v_day + j) % 25 + 1), ',', -1) AS UNSIGNED);
            SET v_item_index = (v_day + j) % 3 + 1;
            SET v_or_qty = 2 + FLOOR(RAND() * 9); -- 2~10개
            SET v_current_date = DATE_ADD(v_current_date, INTERVAL (60*60*8 / v_daily_requests) SECOND); -- 하루 8시간 동안 요청 분배

SELECT item_volume INTO v_item_volume FROM items WHERE item_index = v_item_index;
SET v_total_volume = v_or_qty * v_item_volume;

            -- [로직 1: 재고 탐색]
            -- (이 아이템을, 이 수량만큼 가진 창고를 찾음)
SELECT inven_index, warehouse_index, section_index, inven_quantity
INTO v_inven_index, v_warehouse_index, v_section_index, v_current_stock
FROM inventory
WHERE item_index = v_item_index AND inven_quantity > v_or_qty
ORDER BY inven_quantity DESC
    LIMIT 1;

IF v_inven_index IS NULL THEN
                -- === (시나리오 F: 재고 부족 / REJECTED) ===
                INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, reject_detail, created_at, responded_at)
                VALUES (v_user_index, v_item_index, v_or_qty, '수령인F', '010-6666-6666', '00', '주소F', 'F', 'REJECTED', 'PENDING', '출고 거절: 요청하신 상품의 재고가 부족합니다.', v_current_date, v_current_date);
ELSE
                -- 재고가 있으면 창고 정보 GET
SELECT warehouse_zipcode, warehouse_name, warehouse_address
INTO v_zip_code, v_warehouse_name, v_address
FROM warehouse WHERE warehouse_index = v_warehouse_index;

-- [로직 2: 배차 탐색]
-- (이 창고 지역(zip)에, 이 부피(vol)를 감당할 차량을 찾음)
SELECT v.vehicle_index INTO v_vehicle_index
FROM Vehicle v
         JOIN VehicleLocation vl ON v.vehicle_index = vl.vehicle_index
WHERE vl.vl_zip_code = LEFT(v_zip_code, 2) AND v.vehicle_volume > v_total_volume
ORDER BY v.vehicle_volume ASC
    LIMIT 1;

-- 시나리오 분기
SET v_scenario_type = RAND();

                -- === (시나리오 A/E: 60% / 성공 / 배송중 또는 완료) ===
                IF v_scenario_type < 0.6 AND v_vehicle_index IS NOT NULL THEN

                    -- 1. 출고 요청 (승인됨)
                    INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at, responded_at)
                    VALUES (v_user_index, v_item_index, v_or_qty, '수령인A', '010-1111-1111', v_zip_code, v_address, '101호', 'APPROVED', 'APPROVED', v_current_date, v_current_date);
                    SET v_or_index = LAST_INSERT_ID();

                    -- 2. 배차 등록
INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
VALUES (v_current_date, v_warehouse_name, v_address, v_vehicle_index, v_or_index);
SET v_dispatch_index = LAST_INSERT_ID();

                    -- 3. 출고 지시서 생성
INSERT INTO ShippingInstruction (dispatch_index, admin_index, warehouse_index, section_index, si_waybill_status, approved_at)
VALUES (v_dispatch_index, 1, v_warehouse_index, v_section_index, 'APPROVED', v_current_date);
SET v_si_index = LAST_INSERT_ID();

                    -- 4. 재고 차감 및 실사 기록 (중요)
UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index
WHERE inven_index = v_inven_index;

INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt)
VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);

-- 5. 운송장 생성 (50%는 배송중, 50%는 완료)
IF RAND() < 0.5 THEN
                        INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at)
                        VALUES (CONCAT('CJ-A', 10000 + v_or_index), v_si_index, 'IN_TRANSIT', v_current_date);
ELSE
                        INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at, completed_at)
                        VALUES (CONCAT('CJ-E', 20000 + v_or_index), v_si_index, 'DELIVERED', v_current_date, DATE_ADD(v_current_date, INTERVAL 1 DAY));
END IF;

                -- === (시나리오 B: 10% / 거절 / 배차 실패 - 용량/지역) ===
                ELSEIF v_scenario_type < 0.7 OR v_vehicle_index IS NULL THEN
                    INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, reject_detail, created_at, responded_at)
                    VALUES (v_user_index, v_item_index, v_or_qty, '수령인B', '010-2222-2222', v_zip_code, v_address, '202호', 'REJECTED', 'PENDING', '배차 거절: 현재 요청 부피/지역을 처리할 가용 차량이 없습니다.', v_current_date, v_current_date);

                -- === (시나리오 C: 15% / 대기 / 출고 승인) ===
                ELSEIF v_scenario_type < 0.85 THEN
                    INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at)
                    VALUES (v_user_index, v_item_index, v_or_qty, '수령인C', '010-3333-3333', v_zip_code, v_address, '303호', 'PENDING', 'APPROVED', v_current_date);
                    SET v_or_index = LAST_INSERT_ID();

INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
VALUES (v_current_date, v_warehouse_name, v_address, v_vehicle_index, v_or_index);

-- === (시나리오 D: 15% / 대기 / 배차) ===
ELSE
                    INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at)
                    VALUES (v_user_index, v_item_index, v_or_qty, '수령인D', '010-4444-4444', v_zip_code, v_address, '404호', 'PENDING', 'PENDING', v_current_date);
END IF;

END IF;

            SET v_inven_index = NULL; -- 루프 초기화
            SET v_vehicle_index = NULL; -- 루프 초기화
            SET j = j + 1;
END WHILE; -- 일일 루프

        SET v_day = v_day + 1;
END WHILE; -- 30일 루프
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

-- 1. 한달(1200건)간의 출고 요청 상태 요약
SELECT
    DATE(o.created_at) AS 'Date',
    COUNT(*) AS 'Total Requests',
    SUM(CASE WHEN or_approval = 'APPROVED' AND waybill_status = 'DELIVERED' THEN 1 ELSE 0 END) AS 'Delivered',
    SUM(CASE WHEN or_approval = 'APPROVED' AND waybill_status = 'IN_TRANSIT' THEN 1 ELSE 0 END) AS 'In Transit',
    SUM(CASE WHEN or_approval = 'REJECTED' THEN 1 ELSE 0 END) AS 'Rejected',
    SUM(CASE WHEN or_approval = 'PENDING' AND or_dispatch_status = 'APPROVED' THEN 1 ELSE 0 END) AS 'Pending Approval',
    SUM(CASE WHEN or_approval = 'PENDING' AND or_dispatch_status = 'PENDING' THEN 1 ELSE 0 END) AS 'Pending Dispatch'
FROM OutboundRequest o
    LEFT JOIN Dispatch d ON o.or_index = d.or_index
    LEFT JOIN ShippingInstruction si ON d.dispatch_index = si.dispatch_index
    LEFT JOIN Waybill w ON si.si_index = w.si_index
GROUP BY DATE(created_at)
ORDER BY DATE(created_at);

-- 2. 최종 재고 상태 (출고로 인해 차감된)
SELECT
    i.item_index,
    it.item_name,
    w.warehouse_name,
    SUM(i.inven_quantity) AS 'Final Stock'
FROM inventory i
         JOIN items it ON i.item_index = it.item_index
         JOIN warehouse w ON i.warehouse_index = w.warehouse_index
GROUP BY i.item_index, w.warehouse_name
ORDER BY i.item_index, w.warehouse_name;

-- 3. 재고 실사 로그 (재고 차감 이력)
SELECT * FROM inven_count ORDER BY count_index DESC LIMIT 20;