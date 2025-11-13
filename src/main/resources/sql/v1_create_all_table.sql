DROP database if exists wms;
create database wms;

use wms;

-- 테이블 전체 생성 sql
-- ================= ADMIN TABLE =====================
drop table IF EXISTS admin;
create table admin(
                      admin_index Bigint primary key auto_increment,
                      admin_name varchar(50) not null,
                      admin_id varchar(50) not null UNIQUE,
                      admin_pw varchar(255) not null,
                      admin_role ENUM('MASTER','ADMIN') NOT NULL DEFAULT 'ADMIN',
                      admin_phone varchar(50) null,
                      admin_createdAt timestamp default current_timestamp() null,
                      admin_updateAt timestamp default current_timestamp() null,
                      admin_status ENUM('APPROVED','PENDING','REJECTED') NOT NULL DEFAULT 'PENDING'
);


-- ================ USER TABLE ======================
DROP TABLE IF EXISTS users;
create table users(
                      user_index Bigint primary key auto_increment,
                      user_name varchar(50) not null,
                      user_id varchar(50) not null UNIQUE,
                      user_pw varchar(255) not null,
                      user_email varchar(50) null,
                      user_phone varchar(50) null,
                      company_name varchar(255) null,
                      company_code int null,
                      user_createdAt timestamp default current_timestamp() null,
                      user_updateAt timestamp default current_timestamp() null,
                      user_status ENUM('APPROVED','PENDING','REJECTED') NOT NULL DEFAULT 'PENDING'
);

-- ================ ANNOUNCEMENT TABLE ======================

-- 1. 공지사항 테이블 (announcement)
DROP TABLE IF EXISTS announcement;
CREATE TABLE IF NOT EXISTS announcement
(
    notice_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '공지 번호',
    n_title      VARCHAR(100) NOT NULL COMMENT '공지 제목',
    n_content    TEXT         NOT NULL COMMENT '공지 내용',
    n_createAt   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    n_updateAt   DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    n_priority   INT                   DEFAULT 0 COMMENT '중요도 (0: 일반, 1: 중요)',
    admin_index  BIGINT       NOT NULL COMMENT '관리자번호',
    INDEX idx_priority (n_priority),
    INDEX idx_createAt (n_createAt)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='공지사항 테이블';

-- 2. 1:1 문의 테이블 (one_to_one_request)
DROP TABLE IF EXISTS one_to_one_request;
CREATE TABLE IF NOT EXISTS one_to_one_request
(
    request_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '1:1 문의 번호',
    r_title       VARCHAR(100) NOT NULL COMMENT '문의 제목',
    r_content     TEXT         NOT NULL COMMENT '문의 내용',
    r_createAt    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    r_updateAt    DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    r_status      VARCHAR(20)  NOT NULL DEFAULT 'PENDING' COMMENT '답변 상태 (PENDING, ANSWERED)',
    r_type        VARCHAR(50)  NOT NULL COMMENT '문의 유형',
    r_response    TEXT COMMENT '관리자 답변',
    user_index    BIGINT       NOT NULL COMMENT '유저번호',
    admin_index   BIGINT COMMENT '답변한 관리자번호',
    INDEX idx_user (user_index),
    INDEX idx_status (r_status),
    INDEX idx_createAt (r_createAt)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='1:1 문의 테이블';


-- 3. 문의 게시판 테이블 (board_request)
DROP TABLE IF EXISTS board_request;
CREATE TABLE IF NOT EXISTS board_request
(
    board_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글 번호',
    b_title     VARCHAR(100) NOT NULL COMMENT '게시글 제목',
    b_content   TEXT         NOT NULL COMMENT '게시글 내용',
    b_createAt  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    b_updateAt  DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    b_type      VARCHAR(50)  NOT NULL COMMENT '문의 유형',
    b_views     INT                   DEFAULT 0 COMMENT '조회수',
    user_index  BIGINT       NOT NULL COMMENT '작성자번호',
    INDEX idx_user (user_index),
    INDEX idx_createAt (b_createAt),
    INDEX idx_type (b_type)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='문의 게시판 테이블';

-- 4. 문의 게시판 댓글 테이블 (board_comment)
DROP TABLE IF EXISTS board_comment;
CREATE TABLE IF NOT EXISTS board_comment
(
    comment_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글 번호',
    board_index   INT      NOT NULL COMMENT '게시글 번호',
    c_content     TEXT     NOT NULL COMMENT '댓글 내용',
    c_createAt    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    user_index    BIGINT COMMENT '작성자번호 (사용자)',
    admin_index   BIGINT COMMENT '작성자번호 (관리자)',
    INDEX idx_board (board_index),
    INDEX idx_createAt (c_createAt),
    FOREIGN KEY (board_index) REFERENCES board_request (board_index) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='문의 게시판 댓글 테이블';


-- ================ INBOUND TABLE ======================

-- 1. inbound_request 테이블

DROP TABLE IF EXISTS inbound_detail;
DROP TABLE IF EXISTS inbound_request;

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


-- 2. inbound_detail 테이블
CREATE TABLE IF NOT EXISTS inbound_detail
(
    detail_index      bigint AUTO_INCREMENT PRIMARY KEY COMMENT '입고 상세 번호 (PK)',
    inbound_index     bigint       NOT NULL COMMENT '입고 요청 번호 (FK)',
    received_quantity bigint       NOT NULL DEFAULT 0 COMMENT '실제 입고 수량',
    complete_date     DATETIME COMMENT '실제 입고 일시',
    warehouse_index   bigint         NOT NULL COMMENT '창고번호 (FK)',
    section_index     VARCHAR(100) NOT NULL COMMENT '구역 번호',


    CONSTRAINT fk_inbound_request
        FOREIGN KEY (inbound_index) REFERENCES inbound_request (inbound_index)
            ON DELETE CASCADE -- (선택) 요청이 삭제되면 상세 내역도 삭제
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='입고 상세 테이블';


-- ================ INVENTORY TABLE ======================
DROP TABLE IF EXISTS inven_count;
DROP TABLE IF EXISTS inventory;

-- INVENTORY: (item, warehouse, section) 조합은 단 한 행만!
CREATE TABLE IF NOT EXISTS inventory (
                           inven_index      BIGINT       NOT NULL AUTO_INCREMENT,
                           item_index       BIGINT       NOT NULL,
                           warehouse_index  BIGINT       NOT NULL,
                           section_index    BIGINT       NOT NULL,
                           inven_quantity   INT          NOT NULL,
                           inbound_date     DATETIME     NULL,
                           shipping_date    DATETIME     NULL,
                           detail_inbound   BIGINT       NULL,
                           detail_outbound  BIGINT       NULL,
                           PRIMARY KEY (inven_index),

    -- 같은 아이템/창고/구역은 1행만 유지 (중복 방지)
                           UNIQUE KEY uq_inventory_item_wh_sec (item_index, warehouse_index, section_index),

    -- 조회용 인덱스
                           KEY idx_inventory_item (item_index),
                           KEY idx_inventory_wh   (warehouse_index),
                           KEY idx_inventory_sec  (section_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




-- INVEN_COUNT: inventory의 스냅샷(FK로 정확히 연결)
CREATE TABLE IF NOT EXISTS inven_count (
                             count_index      BIGINT       NOT NULL AUTO_INCREMENT,
                             inven_index      BIGINT       NOT NULL,
                             inven_quantity   INT          NOT NULL,
                             actual_quantity  INT          NOT NULL,
                             count_updateAt   DATETIME     NOT NULL,
                             PRIMARY KEY (count_index),

                             KEY idx_inven_count_inven (inven_index),
                             CONSTRAINT fk_inven_count_inventory
                                 FOREIGN KEY (inven_index) REFERENCES inventory(inven_index)
                                     ON DELETE CASCADE
                                     ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- ================ ITEMS TABLE ======================

DROP TABLE IF EXISTS items;
create table items(
                      item_index Bigint auto_increment not NULL primary key,
                      item_name varchar(255) not null,
                      item_price int not null,
                      item_volume int not null,
                      item_category ENUM('HEALTH','BEAUTY','PERFUME','CARE','FOOD') NOT NULL,
                      item_img LONGBLOB  null
);

-- ================ OUTBOUND TABLE ======================

DROP TABLE IF EXISTS OutboundRequest;
CREATE TABLE OutboundRequest (
                                 or_index	BIGINT	NOT NULL,
                                 user_index BIGINT	NOT NULL,
                                 item_index BIGINT	NOT NULL,
                                 or_quantity	int NOT NULL,
                                 or_name	varchar(50) NOT NULL,
                                 or_phone varchar(50) NOT NULL,
                                 or_zip_code varchar(10) NOT NULL,
                                 or_street_address	varchar(100) NOT NULL,
                                 or_detailed_address varchar(100) NOT NULL,
                                 or_approval	ENUM('PENDING', 'APPROVED', 'REJECTED')	NOT NULL DEFAULT 'PENDING' ,
                                 created_at DATETIME	NOT NULL DEFAULT current_timestamp(),
                                 updated_at DATETIME	NOT NULL DEFAULT current_timestamp on update current_timestamp(),
                                 status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST',
                                 or_dispatch_status Enum('PENDING', 'APPROVED') NOT NULL DEFAULT 'PENDING',
                                 responded_at DATETIME NULL,
                                 reject_detail	TEXT NULL
);

DROP TABLE IF EXISTS Dispatch;
CREATE TABLE Dispatch (
                          dispatch_index BIGINT NOT NULL,
                          dispatch_date DATETIME NOT NULL DEFAULT current_timestamp() on update current_timestamp(),
                          start_point	varchar(200)	NOT NULL,
                          end_point	varchar(200)	NOT NULL,
                          vehicle_index BIGINT	NOT NULL,
                          or_index BIGINT NOT NULL,
                          status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST'
);

DROP TABLE IF EXISTS VehicleLocation;
CREATE TABLE VehicleLocation (
                                 vl_index BIGINT NOT NULL,
                                 vehicle_index BIGINT NOT NULL,
                                 vl_zip_code	varchar(2)	NOT NULL,
                                 status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST'
);

DROP TABLE IF EXISTS ShippingInstruction;
CREATE TABLE ShippingInstruction (
                                     si_index BIGINT NOT NULL,
                                     dispatch_index BIGINT NOT NULL,
                                     admin_index BIGINT NOT NULL,
                                     approved_at	DATETIME NOT NULL	DEFAULT current_timestamp(),
                                     warehouse_index BIGINT NOT NULL,
                                     section_index	BIGINT	NOT NULL,
                                     si_waybill_status	ENUM('PENDING', 'APPROVED')	NOT NULL DEFAULT 'PENDING',
                                     status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST'
);

DROP TABLE IF EXISTS Waybill;
CREATE TABLE Waybill (
                         waybill_index BIGINT NOT NULL,
                         waybill_id	varchar(50)	NOT NULL,
                         si_index BIGINT	NOT NULL,
                         created_at	DATETIME	NOT NULL DEFAULT current_timestamp(),
                         completed_at	DATETIME	NULL,
                         waybill_status	ENUM('IN_TRANSIT', 'DELIVERED')	NOT NULL DEFAULT 'IN_TRANSIT'
);

DROP TABLE  IF EXISTS Vehicle;
CREATE TABLE Vehicle (
                         vehicle_index	BIGINT NOT NULL,
                         vehicle_name varchar(50)	NOT NULL,
                         vehicle_id	varchar(30)	NOT NULL,
                         vehicle_volume	int	NOT NULL,
                         vehicle_status	ENUM('PENDING', 'WORKING')	NOT NULL DEFAULT 'PENDING',
                         created_at DATETIME NOT NULL DEFAULT current_timestamp(),
                         updated_at DATETIME NOT NULL DEFAULT current_timestamp on update current_timestamp(),
                         status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST',
                         driver_name varchar(50) NOT NULL,
                         driver_phone varchar(50) NOT NULL
);

-- PK 지정
ALTER TABLE OutboundRequest ADD CONSTRAINT PK_OUTBOUNDREQUEST PRIMARY KEY (or_index);
ALTER TABLE Dispatch ADD CONSTRAINT PK_DISPATCH PRIMARY KEY (dispatch_index);
ALTER TABLE VehicleLocation ADD CONSTRAINT PK_VEHICLELOCATION PRIMARY KEY (vl_index);
ALTER TABLE ShippingInstruction ADD CONSTRAINT PK_SHIPPINGINSTRUCTION PRIMARY KEY (si_index);
ALTER TABLE Waybill ADD CONSTRAINT PK_WAYBILL PRIMARY KEY (waybill_index);
ALTER TABLE Vehicle ADD CONSTRAINT PK_VEHICLE PRIMARY KEY (vehicle_index);



-- AUTO_INCREMENT 지정
ALTER TABLE OutboundRequest MODIFY COLUMN or_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE Dispatch MODIFY COLUMN dispatch_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE VehicleLocation MODIFY COLUMN vl_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE ShippingInstruction MODIFY COLUMN si_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE Waybill MODIFY COLUMN waybill_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE Vehicle MODIFY COLUMN vehicle_index BIGINT NOT NULL AUTO_INCREMENT;



-- 견적서


-- 테이블 생성
DROP TABLE IF EXISTS QuotationRequest;
DROP TABLE IF EXISTS QuotationResponse;
DROP TABLE IF EXISTS QuotationComment;
CREATE TABLE QuotationRequest (
                                  qrequest_index BIGINT NOT NULL,
                                  user_index	BIGINT NOT NULL,
                                  qrequest_name	varchar(50)	NOT NULL,
                                  qrequest_email	varchar(50)	NOT NULL,
                                  qrequest_phone	varchar(50)	NOT NULL,
                                  qrequest_company	varchar(50)	NULL,
                                  qrequest_detail	TEXT	NOT NULL,
                                  qrequest_status	ENUM('PENDING', 'ANSWERED')	NOT NULL DEFAULT 'PENDING',
                                  created_at	DATETIME	NOT NULL DEFAULT current_timestamp(),
                                  updated_at	DATETIME	NOT NULL DEFAULT current_timestamp on update current_timestamp(),
                                  status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST'
);

CREATE TABLE QuotationResponse (
                                   qresponse_index	BIGINT	NOT NULL,
                                   qrequest_index BIGINT NOT NULL,
                                   admin_index BIGINT	NOT NULL,
                                   qresponse_detail	TEXT	NOT NULL,
                                   created_at	DATETIME	NOT NULL DEFAULT current_timestamp(),
                                   updated_at	DATETIME	NOT NULL DEFAULT current_timestamp on update current_timestamp(),
                                   status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST'
);

CREATE TABLE QuotationComment (
                                  qcomment_index	BIGINT	NOT NULL,
                                  qrequest_index BIGINT	NOT NULL,
                                  qcomment_detail	TEXT	NOT NULL,
                                  created_at	DATETIME	NOT NULL DEFAULT current_timestamp(),
                                  updated_at	DATETIME	NOT NULL DEFAULT current_timestamp on update current_timestamp(),
                                  status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST',
                                  writer_type	ENUM('ADMIN', 'USER') NOT NULL DEFAULT 'USER',
                                  user_index	BIGINT	NULL,
                                  admin_index	BIGINT	NULL
);

-- PK 지정
ALTER TABLE QuotationRequest ADD CONSTRAINT PK_QUOTATIONREQUEST PRIMARY KEY (qrequest_index);
ALTER TABLE QuotationResponse ADD CONSTRAINT PK_QUOTATIONRESPONSE PRIMARY KEY (qresponse_index);
ALTER TABLE QuotationComment ADD CONSTRAINT PK_QUOTATIONCOMMENT PRIMARY KEY (qcomment_index);

-- AUTO_INCREMENT 설정
ALTER TABLE QuotationRequest MODIFY COLUMN qrequest_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE QuotationResponse MODIFY COLUMN qresponse_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE QuotationComment MODIFY COLUMN qcomment_index BIGINT NOT NULL AUTO_INCREMENT;


-- WAREHOUSE
DROP TABLE IF EXISTS section;

DROP Table IF EXISTS warehouse;

create table warehouse(
                          warehouse_index Bigint auto_increment primary key,
                          warehouse_code int unique not null,
                          warehouse_name varchar(50) not null,
                          warehouse_size int not null,
                          warehouse_createdAt datetime default current_timestamp not null,
                          warehouse_updatedAt datetime default current_timestamp on update current_timestamp not null,
                          warehouse_location varchar(50) not null,
                          warehouse_address varchar(200) not null,
                          warehouse_zipcode varchar(10) not null,
                          warehouse_status ENUM('NORMAL', 'INSPECTION', 'CLOSED') not null default 'NORMAL'
);

create table section(
                        section_index Bigint auto_increment primary key,
                        section_code int unique not null,
                        section_name varchar(50) not null,
                        section_capacity int not null,
                        warehouse_index bigint not null
);

alter table section
    add constraint fk_warehouse_section
        foreign key (warehouse_index)
            references warehouse(warehouse_index)
            on delete cascade
            on update cascade ;
