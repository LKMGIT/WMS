INSERT INTO inbound_request (inbound_request_quantity, planned_receive_date, approval_status, user_index,
                             warehouse_index)
VALUES (100, '2025-11-15', 'PENDING', 1, 1),
       (200, '2025-11-20', 'APPROVED', 1, 1),
       (150, '2025-11-25', 'CANCELED', 2, 2);

-- 입고 상세 샘플 데이터
INSERT INTO inbound_detail (request_index, qr_code, received_quantity, location)
VALUES (2, 'INBDETAIL1', 200, 'A-01-01'),
       (2, 'INBDETAIL2', 50, 'A-01-02');

select * from inbound_detail;

create database wms;

