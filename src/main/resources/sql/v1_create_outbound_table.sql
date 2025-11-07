-- 테이블 생성
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
                                 reject_detail	TEXT NULL
);

CREATE TABLE Dispatch (
                          dispatch_index BIGINT NOT NULL,
                          dispatch_date DATETIME NOT NULL DEFAULT current_timestamp(),
                          start_point	varchar(200)	NOT NULL,
                          end_point	varchar(200)	NOT NULL,
                          vehicle_index BIGINT	NOT NULL,
                          or_index BIGINT NOT NULL,
                          status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST'
);

CREATE TABLE VehicleLocation (
                                 vl_index BIGINT NOT NULL,
                                 vehicle_index BIGINT NOT NULL,
                                 vl_zip_code	varchar(2)	NOT NULL,
                                 status	ENUM('EXIST', 'DELETED')	NOT NULL	DEFAULT 'EXIST'
);

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

CREATE TABLE Waybill (
                         waybill_index BIGINT NOT NULL,
                         waybill_id	varchar(50)	NOT NULL,
                         si_index BIGINT	NOT NULL,
                         created_at	DATETIME	NOT NULL DEFAULT current_timestamp(),
                         completed_at	DATETIME	NULL,
                         waybill_status	ENUM('IN_TRANSIT', 'DELIVERED')	NOT NULL DEFAULT 'DELIVERED'
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
ALTER TABLE QuotationComment ADD CONSTRAINT PK_QUOTATIONCOMMENT PRIMARY KEY (qcomment_index);
ALTER TABLE Vehicle ADD CONSTRAINT PK_VEHICLE PRIMARY KEY (vehicle_index);



-- AUTO_INCREMENT 지정
ALTER TABLE OutboundRequest MODIFY COLUMN or_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE Dispatch MODIFY COLUMN dispatch_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE VehicleLocation MODIFY COLUMN vl_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE ShippingInstruction MODIFY COLUMN si_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE Waybill MODIFY COLUMN waybill_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE QuotationComment MODIFY COLUMN qcomment_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE Vehicle MODIFY COLUMN vehicle_index BIGINT NOT NULL AUTO_INCREMENT;



-- FK 지정
ALTER TABLE OutboundRequest ADD CONSTRAINT FK_User_TO_OutboundRequest_1 FOREIGN KEY (user_index) REFERENCES User (user_index);
ALTER TABLE OutboundRequest ADD CONSTRAINT FK_Item_TO_OutboundRequest_1 FOREIGN KEY (item_index) REFERENCES Item (item_index);
ALTER TABLE Dispatch ADD CONSTRAINT FK_Vehicle_TO_Dispatch_1 FOREIGN KEY (vehicle_index) REFERENCES Vehicle (vehicle_index);
ALTER TABLE Dispatch ADD CONSTRAINT FK_OutboundRequest_TO_Dispatch_1 FOREIGN KEY (or_index) REFERENCES OutboundRequest (or_index);
ALTER TABLE VehicleLocation ADD CONSTRAINT FK_Vehicle_TO_VehicleLocation_1 FOREIGN KEY (vehicle_index) REFERENCES Vehicle (vehicle_index);
ALTER TABLE ShippingInstruction ADD CONSTRAINT FK_Dispatch_TO_ShippingInstruction_1 FOREIGN KEY (dispatch_index) REFERENCES Dispatch (dispatch_index);
ALTER TABLE ShippingInstruction ADD CONSTRAINT FK_Admin_TO_ShippingInstruction_1 FOREIGN KEY (admin_index) REFERENCES Admin (admin_index);
ALTER TABLE ShippingInstruction ADD CONSTRAINT FK_Warehouse_TO_ShippingInstruction_1 FOREIGN KEY (warehouse_index) REFERENCES Warehouse (warehouse_index);
ALTER TABLE ShippingInstruction ADD CONSTRAINT FK_Section_TO_ShippingInstruction_1 FOREIGN KEY (section_index) REFERENCES Section (section_index);
ALTER TABLE Waybill ADD CONSTRAINT FK_ShippingInstruction_TO_Waybill_1 FOREIGN KEY (si_index) REFERENCES ShippingInstruction (si_index);
ALTER TABLE QuotationComment ADD CONSTRAINT FK_QuotationRequest_TO_QuotationComment_1 FOREIGN KEY (qrequest_index) REFERENCES QuotationRequest (qrequest_index);
ALTER TABLE QuotationComment ADD CONSTRAINT FK_User_TO_QuotationComment_1 FOREIGN KEY (user_index) REFERENCES User (user_index);
ALTER TABLE QuotationComment ADD CONSTRAINT FK_Admin_TO_QuotationComment_1 FOREIGN KEY (admin_index) REFERENCES Admin (admin_index);