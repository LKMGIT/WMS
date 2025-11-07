use sqldb;

create table request
(
    request_index int primary key,
    r_title       varchar(100),
    r_content     varchar(255),
    r_createAt    datetime,
    r_updateAt    datetime,
    r_status      varchar(20),
    r_type        varchar(50),
    r_response    varchar(255),
    user_index    bigint,
    admin_index   bigint,
    foreign key (user_index) references user (user_index),
    foreign key (admin_index) references admin (admin_index)
);

INSERT INTO request (request_index, r_title, r_content, r_createAt, r_updateAt, r_status, r_type, r_response,
                     user_index, admin_index)
VALUES (1, '제품 입고 문의', '지난주에 요청한 A 제품 100개 입고 예정일 확인 부탁드립니다.', '2025-11-01 10:30:00', '2025-11-01 15:45:00', '완료', '입고',
        'A 제품은 11월 7일에 입고 완료 예정입니다.', 201, 301),
       (2, '시스템 오류 신고', '재고 검색 시 종종 서버 에러가 발생합니다.', '2025-11-02 09:00:00', '2025-11-02 09:00:00', '접수', '오류', NULL, 202,
        302),
       (3, '출고 프로세스 변경 요청', 'B 제품 출고 시 포장 방식을 변경하고 싶습니다.', '2025-11-03 14:20:00', '2025-11-04 11:00:00', '처리중', '개선',
        NULL, 203, 301),
       (4, '신규 창고 사용 권한 요청', '새로 생긴 C 창고에 대한 접근 권한을 요청합니다.', '2025-11-04 16:00:00', '2025-11-04 16:00:00', '접수', '권한',
        NULL, 204, 303),
       (5, '계정 정보 수정 문의', '사용자 비밀번호 재설정을 도와주세요.', '2025-11-05 11:10:00', '2025-11-05 14:00:00', '완료', '계정',
        '비밀번호를 초기화했습니다.', 201, 302);


create table notice
(
    notice_index bigint primary key,
    n_title      varchar(100),
    n_content    varchar(255),
    n_createAt   datetime,
    n_updateAt   datetime,
    n_priority   int,
    admin_index  bigint,
    foreign key (admin_index) references admin (admin_index)
);

INSERT INTO notice (notice_index, n_title, n_content, n_createAt, n_updateAt, n_priority, admin_index)
VALUES (101, '전산 시스템 정기 점검 안내', '11월 15일 새벽 2시부터 4시까지 정기 점검이 있습니다.', '2025-11-01 09:00:00', '2025-11-01 09:00:00', 1,
        301),
       (102, '신규 재고 관리 기능 업데이트', '이번 주부터 새로운 재고 라벨링 기능이 적용됩니다.', '2025-11-03 10:30:00', '2025-11-03 10:30:00', 2, 302),
       (103, '배송 지연 공지', '기상 악화로 인해 일부 지역 배송이 1~2일 지연될 수 있습니다.', '2025-11-05 13:00:00', '2025-11-05 13:00:00', 3, 301),
       (104, '보안 강화 조치 안내', '모든 사용자는 주기적으로 비밀번호를 변경해주시기 바랍니다.', '2025-11-06 15:40:00', '2025-11-06 15:40:00', 2, 303),
       (105, '월별 보고서 제출 기한 변경', '12월부터 월별 보고서 제출 기한이 매월 5일로 변경됩니다.', '2025-11-07 10:00:00', '2025-11-07 10:00:00', 3,
        302);