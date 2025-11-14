use wms;


-- 마스터 1명 생성
INSERT INTO admin
(admin_name, admin_id, admin_pw, admin_role, admin_phone, admin_status)
VALUES
    ('시스템마스터', 'master',
     'master', -- 예시 해시
     'MASTER', '010-0000-0000', 'APPROVED');

INSERT INTO admin (admin_name, admin_id, admin_pw, admin_role, admin_phone, admin_status) VALUES
-- MASTER (APPROVED) 3명
('김서준',  'master_2',        '{noop}Master!123',  'MASTER', '010-0000-0000', 'APPROVED'),
('박도윤',  'ops_master',    '{noop}Ops!12345',   'MASTER', '010-1111-2222', 'APPROVED'),
('이하준',  'sys_master',    '{noop}Sys!12345',   'MASTER', '010-2222-3333', 'APPROVED'),

-- MASTER (PENDING/REJECTED) 2명
('최지호',  'pending_master','{noop}Wait!12345',  'MASTER', '010-3333-4444', 'PENDING'),
('정유준',  'rejected_master','{noop}Stop!12345', 'MASTER', '010-4444-5555', 'REJECTED'),

-- ADMIN (APPROVED) 5명
('한서연',  'admin_a', '{noop}AdminA!123', 'ADMIN', '010-1010-1010', 'APPROVED'),
('고지우',  'admin_b', '{noop}AdminB!123', 'ADMIN', '010-2020-2020', 'APPROVED'),
('문하린',  'admin_c', '{noop}AdminC!123', 'ADMIN', '010-3030-3030', 'APPROVED'),
('신도하',  'admin_d', '{noop}AdminD!123', 'ADMIN', '010-4040-4040', 'APPROVED'),
('배서아',  'admin_e', '{noop}AdminE!123', 'ADMIN', '010-5050-5050', 'APPROVED'),

-- ADMIN (PENDING) 3명
('윤민서',  'admin_f', '{noop}AdminF!123', 'ADMIN', '010-6060-6060', 'PENDING'),
('서준우',  'admin_g', '{noop}AdminG!123', 'ADMIN', '010-7070-7070', 'PENDING'),
('이하린',  'admin_h', '{noop}AdminH!123', 'ADMIN', '010-8080-8080', 'PENDING'),

-- ADMIN (REJECTED) 2명
('장도윤',  'admin_i', '{noop}AdminI!123', 'ADMIN', '010-9090-9090', 'REJECTED'),
('최민재',  'admin_j', '{noop}AdminJ!123', 'ADMIN', '010-1212-3434', 'REJECTED');

UPDATE admin
SET admin_status = 'APPROVED',
    admin_updateAt = CURRENT_TIMESTAMP
WHERE admin_id = 'master123';


select * from admin;
