-- 테이블 생성
CREATE TABLE QuotationRequest (
                                  qrequest_index BIGINT NOT NULL,
                                  user_index	BIGINT NOT NULL,
                                  qrequest_name	varchar(50)	NOT NULL,
                                  qrequest_email	varchar(50)	NOT NULL,
                                  qrequest_phone	varchar(50)	NOT NULL,
                                  qrequest_company	varchar(50)	NULL,
                                  qrequest_detail	TEXT	NOT NULL,
                                  qrequest_status	ENUM('PENDING', 'APPROVED')	NOT NULL DEFAULT 'PENDING',
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

-- PK 지정
ALTER TABLE QuotationRequest ADD CONSTRAINT PK_QUOTATIONREQUEST PRIMARY KEY (qrequest_index);
ALTER TABLE QuotationResponse ADD CONSTRAINT PK_QUOTATIONRESPONSE PRIMARY KEY (qresponse_index);


-- AUTO_INCREMENT 설정
ALTER TABLE QuotationRequest MODIFY COLUMN qrequest_index BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE QuotationResponse MODIFY COLUMN qresponse_index BIGINT NOT NULL AUTO_INCREMENT;


-- FK 지정
ALTER TABLE QuotationRequest ADD CONSTRAINT FK_User_TO_QuotationRequest_1 FOREIGN KEY (user_index) REFERENCES User (user_index);
ALTER TABLE QuotationResponse ADD CONSTRAINT FK_QuotationRequest_TO_QuotationResponse_1 FOREIGN KEY (qrequest_index) REFERENCES QuotationRequest (qrequest_index);
ALTER TABLE QuotationResponse ADD CONSTRAINT FK_Admin_TO_QuotationResponse_1 FOREIGN KEY (admin_index) REFERENCES Admin(admin_index);

