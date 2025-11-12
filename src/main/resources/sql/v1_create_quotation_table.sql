-- 테이블 생성
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

-- FK 지정
ALTER TABLE QuotationRequest ADD CONSTRAINT FK_User_TO_QuotationRequest_1 FOREIGN KEY (user_index) REFERENCES User (user_index);
ALTER TABLE QuotationResponse ADD CONSTRAINT FK_QuotationRequest_TO_QuotationResponse_1 FOREIGN KEY (qrequest_index) REFERENCES QuotationRequest (qrequest_index);
ALTER TABLE QuotationResponse ADD CONSTRAINT FK_Admin_TO_QuotationResponse_1 FOREIGN KEY (admin_index) REFERENCES Admin(admin_index);
ALTER TABLE QuotationComment ADD CONSTRAINT FK_QuotationRequest_TO_QuotationComment_1 FOREIGN KEY (qrequest_index) REFERENCES QuotationRequest (qrequest_index);
ALTER TABLE QuotationComment ADD CONSTRAINT FK_User_TO_QuotationComment_1 FOREIGN KEY (user_index) REFERENCES User (user_index);
ALTER TABLE QuotationComment ADD CONSTRAINT FK_Admin_TO_QuotationComment_1 FOREIGN KEY (admin_index) REFERENCES Admin (admin_index);

