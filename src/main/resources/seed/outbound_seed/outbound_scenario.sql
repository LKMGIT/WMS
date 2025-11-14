USE wms;

-- =================================================================
-- 0. 데이터 초기화
-- =================================================================
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE QuotationComment;
TRUNCATE TABLE QuotationResponse;
TRUNCATE TABLE QuotationRequest;
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE QuotationRequest AUTO_INCREMENT = 1;
ALTER TABLE QuotationResponse AUTO_INCREMENT = 1;
ALTER TABLE QuotationComment AUTO_INCREMENT = 1;

-- =================================================================
-- 1. 견적 요청 (100건) 및 견적 답변 (90건) 생성
-- =================================================================
DELIMITER $$
CREATE PROCEDURE `sp_generate_requests_responses`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_qrequest_index BIGINT;
    DECLARE v_user_index BIGINT;
    DECLARE v_admin_index BIGINT;
    DECLARE v_name VARCHAR(50);
    DECLARE v_email VARCHAR(50);
    DECLARE v_phone VARCHAR(50);
    DECLARE v_company VARCHAR(50);
    DECLARE v_req_date DATETIME;
    DECLARE v_status ENUM('PENDING', 'ANSWERED');

    -- admin_data.sql의 'APPROVED' 관리자 9명 (1, 2, 3, 4, 7, 8, 9, 10, 11)
    SET @approved_admins = '1,2,3,4,7,8,9,10,11';

    WHILE i <= 100 DO

            -- User 1~93 순환 (users_data.sql 기준)
            SET v_user_index = (i % 93) + 1;

            -- users 테이블에서 실제 사용자 정보 가져오기
            SELECT user_name, user_email, user_phone, company_name
            INTO v_name, v_email, v_phone, v_company
            FROM users WHERE user_index = v_user_index;

            -- 100일 전부터 하루씩 증가
            SET v_req_date = DATE_SUB('2025-11-14 10:00:00', INTERVAL (100-i) DAY);

            -- 1~90번은 답변, 91~100번은 대기
            IF i <= 90 THEN
                SET v_status = 'ANSWERED';
            ELSE
                SET v_status = 'PENDING';
            END IF;

            -- 1. 견적 요청 (Request) 삽입
            INSERT INTO QuotationRequest
            (user_index, qrequest_name, qrequest_email, qrequest_phone, qrequest_company, qrequest_detail, qrequest_status, created_at, updated_at)
            VALUES
                (v_user_index, v_name, v_email, v_phone, v_company,
                 CONCAT('창고 임대 견적 문의 (', v_company, ' / ', v_name, ') - 요청 번호 #', i, '
화장품(상온) 100평 규모, 3PL(풀필먼트) 월 견적 부탁드립니다.
- 예상 물동량: 월 3,000건
- 보관: 상온 (15~25도)
- 위치: 경기센터 희망'),
                 v_status, v_req_date, v_req_date);

            SET v_qrequest_index = LAST_INSERT_ID();

            -- 2. 견적 답변 (Response) 삽입 (90건만)
            IF i <= 90 THEN
                -- Admin 9명 순환
                SET v_admin_index = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@approved_admins, ',', (i % 9) + 1), ',', -1) AS UNSIGNED);

                INSERT INTO QuotationResponse
                (qrequest_index, admin_index, qresponse_detail, created_at, updated_at)
                VALUES
                    (v_qrequest_index, v_admin_index,
                     CONCAT('Re: 견적 문의 답변 드립니다 (담당자: 관리자', v_admin_index, ')
견적서 PDF 파일 첨부하였습니다.
- 경기센터 상온 100평 (평당 35,000원)
- 3PL (건당 2,800원 * 3,000건)
- WMS 사용료 (월 50,000원)
총...'),
                     DATE_ADD(v_req_date, INTERVAL 1 HOUR), -- 요청 1시간 뒤 답변
                     DATE_ADD(v_req_date, INTERVAL 1 HOUR)
                    );
            END IF;

            SET i = i + 1;
        END WHILE;
END$$
DELIMITER ;

-- =================================================================
-- 2. 견적 댓글 (200건) 생성 (불규칙 배분)
-- =================================================================
DELIMITER $$
CREATE PROCEDURE `sp_generate_comments`()
BEGIN
    DECLARE i BIGINT DEFAULT 1;
    DECLARE j INT;
    DECLARE v_comment_count INT;
    DECLARE v_request_user_index BIGINT;
    DECLARE v_writer_type ENUM('ADMIN', 'USER');
    DECLARE v_admin_index_for_comment BIGINT;
    DECLARE v_user_index_for_comment BIGINT;
    DECLARE v_req_date DATETIME;

    -- admin_data.sql의 'APPROVED' 관리자 9명
    SET @approved_admins = '1,2,3,4,7,8,9,10,11';

    WHILE i <= 100 DO

            -- 원본 요청의 사용자 index와 생성 시간 가져오기
            SELECT user_index, created_at INTO v_request_user_index, v_req_date
            FROM QuotationRequest WHERE qrequest_index = i;

            -- 1. 댓글 수 불규칙 할당 (총 200개)
            IF i <= 10 THEN
                SET v_comment_count = 7 + (i % 3); -- 7, 8, 9 (총 80개)
            ELSEIF i <= 30 THEN
                SET v_comment_count = 3 + (i % 2); -- 3, 4 (총 70개)
            ELSEIF i <= 80 THEN
                SET v_comment_count = 1; -- 1 (총 50개)
            ELSE
                SET v_comment_count = 0; -- 0 (총 0개)
            END IF;

            -- 2. 댓글 수 만큼 삽입
            SET j = 0;
            WHILE j < v_comment_count DO

                    -- 1/3은 ADMIN, 2/3는 USER
                    IF j % 3 = 0 THEN
                        SET v_writer_type = 'ADMIN';
                        SET v_admin_index_for_comment = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@approved_admins, ',', ((i+j) % 9) + 1), ',', -1) AS UNSIGNED);
                        SET v_user_index_for_comment = NULL;
                    ELSE
                        SET v_writer_type = 'USER';
                        SET v_admin_index_for_comment = NULL;
                        SET v_user_index_for_comment = v_request_user_index; -- 원본 요청자
                    END IF;

                    INSERT INTO QuotationComment
                    (qrequest_index, qcomment_detail, created_at, updated_at, writer_type, user_index, admin_index)
                    VALUES
                        (i,
                         CASE
                             WHEN v_writer_type = 'USER' THEN '견적서 잘 받았습니다. 혹시 WMS 데모 사용해볼 수 있나요?'
                             ELSE '네, 고객님. WMS 데모 계정 정보 메일로 발송해 드렸습니다.'
                             END,
                         DATE_ADD(v_req_date, INTERVAL (2+j) HOUR), -- 답변 1시간 뒤부터 순차적
                         DATE_ADD(v_req_date, INTERVAL (2+j) HOUR),
                         v_writer_type,
                         v_user_index_for_comment,
                         v_admin_index_for_comment
                        );

                    SET j = j + 1;
                END WHILE;

            SET i = i + 1;
        END WHILE;
END$$
DELIMITER ;

-- =================================================================
-- 3. 프로시저 실행 및 삭제
-- =================================================================
CALL sp_generate_requests_responses();
CALL sp_generate_comments();

DROP PROCEDURE sp_generate_requests_responses;
DROP PROCEDURE sp_generate_comments;

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
            SET v_item_index = (i % 3) + 1;
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
            SET v_item_index = (i % 3) + 1;
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
-- =================================================================
-- 3. 출고 1200건 생성 (한달 치, 하루 평균 40건)
-- =================================================================
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
                    SET v_item_index = (v_day + j) % 25 + 1;
                    SET v_or_qty = 5 + FLOOR(RAND() * 30); -- 5~34개

                    SELECT item_volume INTO v_item_volume FROM items WHERE item_index = v_item_index;
                    SET v_total_volume = v_or_qty * v_item_volume;

                    -- '총 재고' 탐색 (원본 스키마 기준)
                    SELECT inven_index, warehouse_index, section_index, inven_quantity
                    INTO v_inven_index, v_warehouse_index, v_section_index, v_current_stock
                    FROM inventory
                    WHERE
                        item_index = v_item_index
                      AND inven_quantity > v_or_qty
                    ORDER BY inven_quantity DESC
                    LIMIT 1;

-- 배송지 설정
                    SET v_or_zip_code = SUBSTRING_INDEX(SUBSTRING_INDEX(@zipcodes, ',', (j % 25) + 1), ',', -1);
                    SET v_or_zip_prefix = LEFT(v_or_zip_code, 2);
                    IF v_or_zip_prefix LIKE '0%' THEN SET v_address = '서울특별시';
                    ELSEIF v_or_zip_prefix LIKE '1%' THEN SET v_address = '경기';
                    ELSE SET v_address = '충남';
                    END IF;


                    IF v_inven_index IS NULL THEN
                        -- === (시나리오 F: 재고 부족 / REJECTED) ===
                        INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, reject_detail, created_at, responded_at)
                        VALUES (v_user_index, v_item_index, v_or_qty, '수령인F', '010-6666-6666', v_or_zip_code, v_address, '재고부족', 'REJECTED', 'PENDING',
                                '출고 거절: 요청하신 상품의 재고가 부족합니다.',
                                v_current_date, v_current_date);

                        -- === "마지막 날" (v_day = 29) 에만 '대기' 상태 생성 ===
                    ELSEIF v_day = 29 AND (v_current_hour >= 14 AND v_current_hour < 23) THEN
                        -- === (시나리오 G: 운행 시간 마감 / PENDING) ===

                        -- ######## [수정됨] '운행시간' 대신 실제 주소 예시를 넣습니다. ########
                        INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at)
                        VALUES (v_user_index, v_item_index, v_or_qty, '수령인G', '010-7777-7777', v_or_zip_code, v_address, '505호', 'PENDING', 'PENDING', v_current_date);

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

                        -- === 과거 (v_day < 29)에는 REJECTED 또는 DELIVERED만 ===
                        IF v_day < 29 AND v_vehicle_index IS NULL THEN
                            -- (과거) 배차 실패 -> 영구 거절
                            INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, reject_detail, created_at, responded_at)
                            VALUES (v_user_index, v_item_index, v_or_qty, '수령인B', '010-2222-2222', v_or_zip_code, v_address, '202호', 'REJECTED', 'PENDING',
                                    CONCAT('배차 거절: 요청 부피(', v_total_volume, ') 또는 지역(', v_or_zip_prefix, ')을 처리할 가용 차량이 없습니다.'),
                                    v_current_date, v_current_date);

                        ELSEIF v_day < 29 AND v_vehicle_index IS NOT NULL THEN
                            -- (과거) 배차 성공 -> 무조건 DELIVERED (재고 차감)
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

                            SET v_completion_time = DATE_ADD(DATE(v_current_date), INTERVAL 14 + (j % 8) HOUR);

                            INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at, completed_at)
                            VALUES (CONCAT('CJ-E', 20000 + v_or_index), v_si_index, 'DELIVERED', v_current_date, v_completion_time);

-- === "마지막 날" (v_day = 29)에만 PENDING 분배 ===
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
                                UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;
                                SET v_completion_time = DATE_ADD(DATE(v_current_date), INTERVAL 14 + (j % 8) HOUR);
                                INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at, completed_at)
                                VALUES (CONCAT('07', DATE_FORMAT(v_current_date, '%Y%m%d'), LPAD(v_si_index, 6, '0')), v_si_index, 'DELIVERED', v_current_date, v_completion_time);

                                -- ######## [수정됨] Day 29에는 재고를 미리 차감하지 않습니다. ########
-- UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index WHERE inven_index = v_inven_index;
-- INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt) VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);


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
                                UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;
                                INSERT INTO Waybill (waybill_id, si_index, waybill_status, created_at)
                                VALUES (CONCAT('CJ-A', 10000 + v_or_index), v_si_index, 'IN_TRANSIT', v_current_date);

                                -- ######## [수정됨] Day 29에는 재고를 미리 차감하지 않습니다. ########
-- UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index WHERE inven_index = v_inven_index;
-- INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt) VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);


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
                                UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;

                                -- ######## [수정됨] Day 29에는 재고를 미리 차감하지 않습니다. ########
-- UPDATE inventory SET inven_quantity = inven_quantity - v_or_qty, shipping_date = v_current_date, detail_outbound = v_or_index WHERE inven_index = v_inven_index;
-- INSERT INTO inven_count (inven_index, inven_quantity, actual_quantity, count_updateAt) VALUES (v_inven_index, (v_current_stock), (v_current_stock - v_or_qty), v_current_date);


                            ELSE -- (20%) PENDING_APPROVAL
                                INSERT INTO OutboundRequest (user_index, item_index, or_quantity, or_name, or_phone, or_zip_code, or_street_address, or_detailed_address, or_approval, or_dispatch_status, created_at)
                                VALUES (v_user_index, v_item_index, v_or_qty, '수령인C', '010-3333-3333', v_or_zip_code, v_address, '303호', 'PENDING', 'APPROVED', v_current_date);
                                SET v_or_index = LAST_INSERT_ID();
                                INSERT INTO Dispatch (dispatch_date, start_point, end_point, vehicle_index, or_index)
                                VALUES (v_current_date, (SELECT warehouse_name FROM warehouse WHERE warehouse_index = v_warehouse_index), v_address, v_vehicle_index, v_or_index);
                                UPDATE temp_vehicle_capacity SET available_volume = available_volume - v_total_volume WHERE vehicle_index = v_vehicle_index;

-- (이곳은 원래부터 재고 차감 로직이 없었으므로 수정할 필요 없음)

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

CALL sp_generate_monthly_outbounds();
DROP PROCEDURE sp_generate_monthly_outbounds;













SET GLOBAL event_scheduler = ON;
CREATE EVENT auto_update_vehicle_status
    ON SCHEDULE EVERY 5 MINUTE -- 5분마다 실행
    DO
    BEGIN

        UPDATE Vehicle V

            -- 차량에 연결된 '오늘의' 배차 건을 찾음
            JOIN Dispatch D ON V.vehicle_index = D.vehicle_index

            -- 배차가 '완료'되었는지 확인하기 위해 Waybill 테이블까지 JOIN
            LEFT JOIN ShippingInstruction SI ON D.dispatch_index = SI.dispatch_index
            LEFT JOIN Waybill W ON SI.si_index = W.si_index

        SET V.vehicle_status =
                CASE
                    -- 1순위: 배송이 이미 완료됐다면(completed_at이 찍혔다면) 무조건 'PENDING'
                    WHEN W.completed_at IS NOT NULL THEN 'PENDING'

                    -- 2순위: (아직 완료 안됐고) 현재 시간이 14:00~23:00 사이라면 'WORKING'
                    WHEN CURTIME() BETWEEN '14:00:00' AND '23:00:00' THEN 'WORKING'

                    -- 3순위: (아직 완료 안됐고) 그 외 시간(새벽 등)이라면 'PENDING'
                    ELSE 'PENDING'
                    END

        WHERE
          -- 오늘 날짜의 배차 건에 대해서만 실행
            DATE(D.dispatch_date) = CURDATE()

          -- (중요) 이미 배송 완료된 건은 매번 업데이트할 필요가 없도록 제외
          -- (단, WORKING -> PENDING으로 바꾸는 시점은 포함해야 함)
          AND (W.completed_at IS NULL OR V.vehicle_status = 'WORKING');

    END;
