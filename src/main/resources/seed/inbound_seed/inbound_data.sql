INSERT INTO inbound_request
(inbound_index, inbound_request_quantity, inbound_request_date, planned_receive_date, approval_status, approve_date, cancel_reason, user_index, warehouse_index, item_index)
VALUES
    (1, 100, '2025-11-01 10:00:00', '2025-11-10', 'APPROVED', '2025-11-02 09:00:00', NULL, 101, 1, 1001),
    (2, 50,  '2025-11-02 11:00:00', '2025-11-12', 'PENDING',  NULL, NULL, 102, 1, 1002),
    (3, 200, '2025-11-03 14:30:00', '2025-11-13', 'REJECTED', NULL, NULL, 101, 2, 1003),
    (4, 30,  '2025-11-04 09:15:00', '2025-11-14', 'CANCELED', NULL, '사용자 단순 변심', 103, 1, 1001),
    (5, 150, '2025-11-05 16:00:00', '2025-11-15', 'APPROVED', '2025-11-06 10:00:00', NULL, 102, 2, 1004),
    (6, 80,  '2025-11-06 17:00:00', '2025-11-16', 'PENDING',  NULL, NULL, 101, 1, 1005),
    (7, 120, '2025-11-07 10:30:00', '2025-11-17', 'APPROVED', '2025-11-08 11:00:00', NULL, 103, 2, 1002),
    (8, 60,  '2025-11-08 11:45:00', '2025-11-18', 'PENDING',  NULL, NULL, 101, 1, 1003),
    (9, 90,  '2025-11-09 13:00:00', '2025-11-19', 'CANCELED', NULL, '제품 단종', 102, 2, 1004),
    (10, 250, '2025-11-10 15:00:00', '2025-11-20', 'APPROVED', '2025-11-11 09:30:00', NULL, 103, 1, 1005);


INSERT INTO inbound_detail
(detail_index, inbound_index, received_quantity, complete_date, warehouse_index, section_index)
VALUES
    (1, 1, 50, '2025-11-10 10:00:00', 1, 'A-01-01'),
    (2, 1, 50, '2025-11-10 10:05:00', 1, 'A-01-02'),
    (3, 2, 0,  NULL, 1, 'A-01-03'),
    (4, 5, 150, '2025-11-15 09:30:00', 2, 'B-01-01'),
    (5, 6, 0,  NULL, 1, 'A-02-01'),
    (6, 7,100, '2025-11-17 14:00:00', 2, 'B-02-01'),
    (7, 7,0,  NULL, 2, 'B-02-02'),
    (8, 8,0,  NULL, 1, 'A-03-01'),
    (9, 9,250, '2025-11-20 11:00:00', 1, 'C-01-01'),
    (10, 2,0,  NULL, 1, 'A-01-04');