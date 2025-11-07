use sqldb;

create table inboundRequest
(
    inbound_index            bigint auto_increment primary key,
    inbound_request_quantity int,
    inbound_request_date     date,
    planned_receive_date     varchar(20),
    approval_status          datetime,
    approve_date             datetime,
    cancel_reason            varchar(255),
    updated_date             datetime,
    user_index               bigint,
    warehouse_index          int,
    foreign key (user_index) references user (user_index),
    foreign key (warehouse_index) references warehouse (warehouse_index)
);

INSERT INTO inboundRequest (inbound_request_quantity, inbound_request_date, planned_receive_date, approval_status,
                            approve_date, cancel_reason, updated_date, user_index, warehouse_index)
VALUES (500, '2025-10-25', '2025-11-05', '2025-10-26 10:00:00', '2025-10-26 10:00:00', NULL, '2025-10-26 10:00:00', 101,
        10),
       (120, '2025-10-28', '2025-11-08', NULL, NULL, NULL, '2025-10-28 14:30:00', 102, 11),
       (300, '2025-10-30', '2025-11-10', '2025-10-30 15:20:00', '2025-10-30 15:20:00', NULL, '2025-10-30 15:20:00', 103,
        10),
       (80, '2025-11-01', '2025-11-12', '2025-11-02 09:15:00', '2025-11-02 09:15:00', NULL, '2025-11-02 09:15:00', 104,
        12),
       (250, '2025-11-04', '2025-11-15', NULL, NULL, '재고 과다', '2025-11-04 11:40:00', 101, 11);

create table inboundDetail
(
    detail_index      bigint primary key,
    request_index     bigint,
    qr_code           varchar(255),
    received_quantity int,
    complete_date     datetime,
    inbound_index     bigint,
    foreign key (inbound_index) references inboundrequest (inboard_index)

);

INSERT INTO inboundDetail (detail_index, request_index, qr_code, received_quantity, complete_date, inbound_index)
VALUES (1001, 1, 'QR500123', 500, '2025-11-05 11:30:00', 1),
       (1002, 2, 'QR120456', 0, NULL, 2),
       (1003, 3, 'QR300789', 300, '2025-11-10 14:00:00', 3),
       (1004, 4, 'QR080112', 80, '2025-11-12 10:10:00', 4),
       (1005, 5, 'QR250334', 0, NULL, 5);