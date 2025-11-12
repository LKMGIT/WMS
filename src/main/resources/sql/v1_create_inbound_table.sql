CREATE TABLE inbound_request
(
    inbound_index            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '입고 번호 (PK)',
    inbound_request_quantity INT         NOT NULL COMMENT '요청 수량',
    inbound_request_date     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '요청 일자',
    planned_receive_date     DATE COMMENT '희망 입고 날짜',
    approval_status          VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '승인 상태 (PENDING, APPROVED, REJECTED, CANCELED)',
    approve_date             DATETIME COMMENT '승인 일시',
    cancel_reason            VARCHAR(255) COMMENT '취소 사유',
    updated_date             DATETIME             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    user_index               BIGINT      NOT NULL COMMENT '유저번호 (FK)',
    warehouse_index          BIGINT      NOT NULL COMMENT '창고번호 (FK)',
    INDEX idx_user (user_index),
    INDEX idx_warehouse (warehouse_index),
    INDEX idx_status (approval_status),
    INDEX idx_request_date (inbound_request_date)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='입고 요청 테이블';


CREATE TABLE inbound_detail
(
    detail_index      INT AUTO_INCREMENT PRIMARY KEY COMMENT '입고 상세 번호 (PK)',
    request_index     BIGINT NOT NULL COMMENT '요청 번호 (FK)',
    qr_code           VARCHAR(100) UNIQUE COMMENT 'QR 코드 값',
    received_quantity INT COMMENT '실제 입고 수량',
    complete_date     DATETIME COMMENT '실제 입고 일시',
    inbound_index     BIGINT COMMENT '입고번호 (FK)',
    location          VARCHAR(255) COMMENT '입고 위치',
    INDEX idx_request (request_index),
    INDEX idx_qr_code (qr_code),
    FOREIGN KEY (request_index) REFERENCES inbound_request (inbound_index) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='입고 상세 테이블';


-- 1. 입고 요청 등록 (insertRequest)
DELIMITER //
CREATE PROCEDURE sp_insert_inbound_request(
    IN p_inbound_request_quantity INT,
    IN p_planned_receive_date DATE,
    IN p_user_index BIGINT,
    IN p_warehouse_index BIGINT,
    OUT p_inbound_index BIGINT
)
BEGIN
    INSERT INTO inbound_request (inbound_request_quantity,
                                 inbound_request_date,
                                 planned_receive_date,
                                 approval_status,
                                 user_index,
                                 warehouse_index)
    VALUES (p_inbound_request_quantity,
            NOW(),
            p_planned_receive_date,
            'PENDING',
            p_user_index,
            p_warehouse_index);

    SET p_inbound_index = LAST_INSERT_ID();
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

-- 3. 입고 요청 목록 조회 (selectRequests) - 검색 조건 포함
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

-- 4. 입고 요청 수정 (updateRequest)
DELIMITER //
CREATE PROCEDURE sp_update_inbound_request(
    IN p_inbound_index BIGINT,
    IN p_inbound_request_quantity INT,
    IN p_planned_receive_date DATE
)
BEGIN
    UPDATE inbound_request
    SET inbound_request_quantity = p_inbound_request_quantity,
        planned_receive_date     = p_planned_receive_date,
        updated_date             = NOW()
    WHERE inbound_index = p_inbound_index;
END //
DELIMITER ;

-- 5. 입고 요청 삭제 (deleteRequest)
DELIMITER //
CREATE PROCEDURE sp_delete_inbound_request(
    IN p_inbound_index BIGINT
)
BEGIN
    DELETE
    FROM inbound_request
    WHERE inbound_index = p_inbound_index;
END //
DELIMITER ;

-- 6. 입고 요청 취소 (updateCancel)
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

-- 7. 입고 요청 승인 (updateApproval)
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

-- 8. 입고 상세 추가 (insertDetail)
DELIMITER //
CREATE PROCEDURE sp_insert_inbound_detail(
    IN p_request_index BIGINT,
    IN p_qr_code VARCHAR(100),
    IN p_received_quantity INT,
    IN p_location VARCHAR(255),
    OUT p_detail_index INT
)
BEGIN
    INSERT INTO inbound_detail (request_index,
                                qr_code,
                                received_quantity,
                                complete_date,
                                location)
    VALUES (p_request_index,
            p_qr_code,
            p_received_quantity,
            NOW(),
            p_location);

    SET p_detail_index = LAST_INSERT_ID();
END //
DELIMITER ;

-- 9. 요청번호로 입고 상세 목록 조회 (selectDetailsByRequestId)
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

-- 10. QR코드로 입고 상세 조회 (selectDetailByQr)
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

-- 11. 입고 상세 수정 (updateDetail)
DELIMITER //
CREATE PROCEDURE sp_update_inbound_detail(
    IN p_detail_index INT,
    IN p_received_quantity INT,
    IN p_location VARCHAR(255)
)
BEGIN
    UPDATE inbound_detail
    SET received_quantity = p_received_quantity,
        location          = p_location
    WHERE detail_index = p_detail_index;
END //
DELIMITER ;

-- 12. 입고 상세 완료 처리 (updateComplete)
DELIMITER //
CREATE PROCEDURE sp_complete_inbound_detail(
    IN p_detail_index INT,
    IN p_received_quantity INT
)
BEGIN
    UPDATE inbound_detail
    SET received_quantity = p_received_quantity,
        complete_date     = NOW()
    WHERE detail_index = p_detail_index;
END //
DELIMITER ;

-- 13. 입고 상세 삭제 (deleteDetail)
DELIMITER //
CREATE PROCEDURE sp_delete_inbound_detail(
    IN p_detail_index INT
)
BEGIN
    DELETE
    FROM inbound_detail
    WHERE detail_index = p_detail_index;
END //
DELIMITER ;

-- 14. 기간별 입고 현황 조회 (selectPeriodStatus)
DELIMITER //
CREATE PROCEDURE sp_select_inbound_status_by_period(
    IN p_start_date VARCHAR(10),
    IN p_end_date VARCHAR(10),
    IN p_user_index BIGINT
)
BEGIN
    SELECT ir.*,
           COUNT(id.detail_index)    as detail_count,
           SUM(id.received_quantity) as total_received_quantity
    FROM inbound_request ir
             LEFT JOIN inbound_detail id ON ir.inbound_index = id.request_index
    WHERE ir.inbound_request_date BETWEEN p_start_date AND p_end_date
      AND (p_user_index IS NULL OR ir.user_index = p_user_index)
    GROUP BY ir.inbound_index
    ORDER BY ir.inbound_request_date DESC;
END //
DELIMITER ;

-- 15. 월별 입고 현황 조회 (selectMonthlyStatus)
DELIMITER //
CREATE PROCEDURE sp_select_inbound_status_by_month(
    IN p_year INT,
    IN p_month INT
)
BEGIN
    SELECT ir.*,
           COUNT(id.detail_index)    as detail_count,
           SUM(id.received_quantity) as total_received_quantity
    FROM inbound_request ir
             LEFT JOIN inbound_detail id ON ir.inbound_index = id.request_index
    WHERE YEAR(ir.inbound_request_date) = p_year
      AND MONTH(ir.inbound_request_date) = p_month
    GROUP BY ir.inbound_index
    ORDER BY ir.inbound_request_date DESC;
END //
DELIMITER ;