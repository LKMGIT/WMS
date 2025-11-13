CREATE TABLE inbound_request
(
    inbound_index            bigint AUTO_INCREMENT PRIMARY KEY COMMENT '입고 번호 (PK)',
    inbound_receive_quantity bigint      NOT NULL COMMENT '요청 수량 (INT로 수정)',
    inbound_request_date     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '요청 일자',
    planned_receive_date     DATE        NOT NULL COMMENT '희망 입고 날짜',
    approval_status          VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '승인 상태 (PENDING, APPROVED, REJECTED, CANCELED)',
    approve_date             DATETIME COMMENT '승인 일시',
    cancel_reason            VARCHAR(255) COMMENT '취소 사유',
    updated_date             DATETIME             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    user_index               BIGINT      NOT NULL COMMENT '유저번호 (FK)',
    warehouse_index          int         NOT NULL COMMENT '창고번호 (FK)',
    item_index               bigint      NOT NULL COMMENT '아이템번호 (FK)',

    INDEX idx_user (user_index),
    INDEX idx_warehouse (warehouse_index),
    INDEX idx_item (item_index)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='입고 요청 테이블';

CREATE TABLE IF NOT EXISTS inbound_detail
(
    detail_index      bigint AUTO_INCREMENT PRIMARY KEY COMMENT '입고 상세 번호 (PK)',
    request_index     bigint       NOT NULL COMMENT '요청 번호',
    qr_code           VARCHAR(255) NOT NULL UNIQUE COMMENT 'QR 코드 값',
    received_quantity bigint       NOT NULL COMMENT '실제 입고 수량',
    complete_date     DATETIME COMMENT '실제 입고 일시',
    inbound_index     bigint       NOT NULL COMMENT '입고 번호 (FK)',
    warehouse_index   int          NOT NULL COMMENT '창고번호 (FK)',
    section_index     VARCHAR(100) NOT NULL COMMENT '구역 번호',

    INDEX idx_request (request_index),
    INDEX idx_inbound (inbound_index)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='입고 상세 테이블';


-- 1. 입고 요청 목록 조회 (selectRequests)
DELIMITER //
CREATE PROCEDURE sp_select_inbound_requests(
    IN p_keyword VARCHAR(100),
    IN p_status VARCHAR(20),
    IN p_user_index BIGINT
)
BEGIN
    SELECT *
    FROM inbound_request
    WHERE 1 = 1
      AND (p_keyword IS NULL OR inbound_index LIKE CONCAT('%', p_keyword, '%'))
      AND (p_status IS NULL OR approval_status = p_status)
      AND (p_user_index IS NULL OR user_index = p_user_index)
    ORDER BY inbound_request_date DESC;
END //
DELIMITER ;

-- 2. 입고 요청 단건 조회 (selectRequestById)
DELIMITER //
CREATE PROCEDURE sp_select_inbound_request_by_id(
    IN p_inbound_index BIGINT
)
BEGIN
    SELECT *
    FROM inbound_request
    WHERE inbound_index = p_inbound_index;
END //
DELIMITER ;


-- 3. 입고 요청 취소 (updateCancel) - 관리자 강제 취소 시 사용
DELIMITER //
CREATE PROCEDURE sp_cancel_inbound_request(
    IN p_inbound_index BIGINT,
    IN p_cancel_reason VARCHAR(255)
)
BEGIN
    UPDATE inbound_request
    SET approval_status = 'CANCELED',
        cancel_reason   = p_cancel_reason,
        updated_date    = NOW()
    WHERE inbound_index = p_inbound_index;
END //
DELIMITER ;

-- 4. 입고 요청 승인 (updateApproval) - 관리자 승인 기능
DELIMITER //
CREATE PROCEDURE sp_approve_inbound_request(
    IN p_inbound_index BIGINT
)
BEGIN
    UPDATE inbound_request
    SET approval_status = 'APPROVED',
        approve_date    = NOW(),
        updated_date    = NOW()
    WHERE inbound_index = p_inbound_index;
END //
DELIMITER ;


-- 5. 입고 상세 등록 (insertDetail) - ★ DTO 타입(VARCHAR) 반영 ★
DELIMITER //
CREATE PROCEDURE sp_insert_inbound_detail(
    IN p_request_index BIGINT,
    IN p_qr_code VARCHAR(100),
    IN p_section_index VARCHAR(100), -- ★ VARCHAR로 수정
    OUT p_detail_index INT -- ★ INT로 수정
)
BEGIN
    INSERT INTO inbound_detail (request_index, qr_code, section_index)
    VALUES (p_request_index,
            p_qr_code,
            p_section_index);

    SET p_detail_index = LAST_INSERT_ID();
END //
DELIMITER ;

-- 6. 요청번호로 입고 상세 목록 조회 (selectDetailsByRequestId)
DELIMITER //
CREATE PROCEDURE sp_select_details_by_request_id(
    IN p_request_index BIGINT
)
BEGIN
    SELECT *
    FROM inbound_detail
    WHERE request_index = p_request_index
    ORDER BY detail_index DESC;
END //
DELIMITER ;

-- 7. QR코드로 입고 상세 조회 (selectDetailByQr) - 관리자 QR 조회 시 사용
DELIMITER //
CREATE PROCEDURE sp_select_detail_by_qr(
    IN p_qr_code VARCHAR(100)
)
BEGIN
    SELECT *
    FROM inbound_detail
    WHERE qr_code = p_qr_code;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_update_inbound_detail(
    IN p_detail_index INT,
    IN p_received_quantity BIGINT,
    -- ▲▲▲ [수정됨] ▲▲▲
    IN p_section_index VARCHAR(100)
)
BEGIN
    UPDATE inbound_detail
    SET received_quantity = p_received_quantity,
        section_index     = p_section_index
    WHERE detail_index = p_detail_index;
END //
DELIMITER ;


-- 10. 입고 상세 완료 처리 (updateComplete)
DELIMITER //
CREATE PROCEDURE sp_complete_inbound_detail(
    IN p_detail_index INT,
    IN p_received_quantity BIGINT
)
BEGIN
    UPDATE inbound_detail
    SET received_quantity = p_received_quantity,
        complete_date     = NOW()
    WHERE detail_index = p_detail_index;
END //
DELIMITER ;

-- 11. 기간별 입고 현황 조회 (selectPeriodStatus)
DELIMITER //
CREATE PROCEDURE sp_select_inbound_status_by_period(
    IN p_start_date VARCHAR(10),
    IN p_end_date VARCHAR(10),
    IN p_user_index BIGINT
)
BEGIN
    SELECT ir.*,
           COUNT(id.detail_index)                    as detail_count,
           CAST(SUM(id.received_quantity) AS SIGNED) as total_received_quantity

    FROM inbound_request ir
             LEFT JOIN inbound_detail id ON ir.inbound_index = id.request_index
    WHERE ir.inbound_request_date BETWEEN p_start_date AND p_end_date
      AND (p_user_index IS NULL OR ir.user_index = p_user_index)
    GROUP BY ir.inbound_index;
END //
DELIMITER ;

-- 12. 월별 입고 현황 조회 (selectMonthlyStatus)
DELIMITER //
CREATE PROCEDURE sp_select_inbound_status_by_month(
    IN p_year INT,
    IN p_month INT
)
BEGIN
    SELECT ir.*,
           COUNT(id.detail_index)                    as detail_count,
           CAST(SUM(id.received_quantity) AS SIGNED) as total_received_quantity
    -- ▲▲▲ [수정됨] ▲▲▲
    FROM inbound_request ir
             LEFT JOIN inbound_detail id ON ir.inbound_index = id.request_index
    WHERE YEAR(ir.inbound_request_date) = p_year
      AND MONTH(ir.inbound_request_date) = p_month
    GROUP BY ir.inbound_index;
END //
DELIMITER ;