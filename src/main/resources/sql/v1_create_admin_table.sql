use wms;

drop table admin;
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

