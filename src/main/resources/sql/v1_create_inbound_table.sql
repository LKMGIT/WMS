use wms;
-- 1. inbound_request 테이블
drop table if exists inbound_request;
CREATE TABLE inbound_request
(
    inbound_index            bigint AUTO_INCREMENT PRIMARY KEY COMMENT '입고 번호 (PK)',
    inbound_request_quantity bigint      NOT NULL COMMENT '요청 수량',
    inbound_request_date     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '요청 일자',
    planned_receive_date     DATE        NOT NULL COMMENT '희망 입고 날짜',
    approval_status          VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '승인 상태 (PENDING, APPROVED, REJECTED, CANCELED)',
    approve_date             DATETIME COMMENT '승인 일시',
    cancel_reason            VARCHAR(255) COMMENT '취소 사유',
    updated_date             DATETIME             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    user_index               BIGINT      NOT NULL COMMENT '유저번호 (FK)',
    warehouse_index          BIGINT        NOT NULL COMMENT '창고번호 (FK)',
    item_index               bigint      NOT NULL COMMENT '아이템번호 (FK)',

    INDEX idx_user (user_index),
    INDEX idx_warehouse (warehouse_index),
    INDEX idx_item (item_index)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='입고 요청 테이블';

DROP TABLE IF EXISTS inbound_detail;
DROP TABLE IF EXISTS inbound_request;

-- 2. inbound_detail 테이블
CREATE TABLE IF NOT EXISTS inbound_detail
(
    detail_index      bigint AUTO_INCREMENT PRIMARY KEY COMMENT '입고 상세 번호 (PK)',
    inbound_index     bigint       NOT NULL COMMENT '입고 요청 번호 (FK)',
    received_quantity bigint       NOT NULL DEFAULT 0 COMMENT '실제 입고 수량',
    complete_date     DATETIME COMMENT '실제 입고 일시',
    warehouse_index   bigint         NOT NULL COMMENT '창고번호 (FK)',
    section_index     bigint NOT NULL comment '구역 번호',


    CONSTRAINT fk_inbound_request
        FOREIGN KEY (inbound_index) REFERENCES inbound_request (inbound_index)
            ON DELETE CASCADE -- (선택) 요청이 삭제되면 상세 내역도 삭제
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='입고 상세 테이블';


select * from inbound_request;
select * from inbound_detail;
