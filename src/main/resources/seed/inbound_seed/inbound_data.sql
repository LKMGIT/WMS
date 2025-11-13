INSERT INTO inbound_request (inbound_index,
    inbound_request_quantity, inbound_request_date, planned_receive_date,
    approval_status, approve_date, cancel_reason,
    user_index, warehouse_index, item_index
) VALUES
(31, 110, '2025-11-14 09:00:00', '2025-11-25', 'PENDING', NULL, NULL, 1, 1, 1001),
(32, 75,  '2025-11-14 10:30:00', '2025-11-26', 'PENDING', NULL, NULL, 2, 2, 1002),
(33, 300, '2025-11-14 11:00:00', '2025-11-27', 'PENDING', NULL, NULL, 3, 1, 1003),
(34, 500, '2025-11-15 08:45:00', '2025-11-28', 'PENDING', NULL, NULL, 4, 3, 1004),
(35, 250, '2025-11-15 09:30:00', '2025-11-29', 'PENDING', NULL, NULL, 1, 3, 1005),
(36, 180, '2025-11-15 10:15:00', '2025-11-30', 'PENDING', NULL, NULL, 2, 1, 1001),
(37, 95,  '2025-11-16 08:00:00', '2025-12-01', 'PENDING', NULL, NULL, 3, 3, 1002),
(38, 400, '2025-11-16 09:00:00', '2025-12-02', 'PENDING', NULL, NULL, 4, 3, 1003),
(39, 220, '2025-11-16 10:00:00', '2025-12-03', 'PENDING', NULL, NULL, 1, 2, 1004),
(40, 130, '2025-11-16 11:00:00', '2025-12-04', 'PENDING', NULL, NULL, 2, 2, 1005);