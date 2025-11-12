create table warehouse(
    warehouse_index Bigint auto_increment primary key,
    warehouse_code varchar(50) unique not null,
    warehouse_name varchar(50) not null,
    warehouse_size int not null,
    warehouse_createdAt datetime default current_timestamp not null,
    warehouse_updatedAt datetime default current_timestamp not null,
    warehouse_location varchar(50) not null,
    warehouse_address varchar(200) not null,
    warehouse_zipcode varchar(10) not null,
    warehouse_status ENUM('NORMAL', 'INSPECTION', 'CLOSED') not null default 'NORMAL'
);

create table section(
    section_index Bigint auto_increment primary key,
    section_code varchar(50) unique not null,
    section_name varchar(50) not null,
    section_capacity int not null
);

ALTER TABLE Section ADD CONSTRAINT FK_Warehouse_Section FOREIGN KEY (warehouse_index)
    REFERENCES Warehouse (warehouse_index);