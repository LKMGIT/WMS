create table warehouse(
    warehouse_index Bigint auto_increment primary key,
    warehouse_code int unique not null,
    warehouse_name varchar(50) not null,
    warehouse_size int not null,
    warehouse_createdAt datetime default current_timestamp not null,
    warehouse_updatedAt datetime default current_timestamp on update current_timestamp not null,
    warehouse_location varchar(50) not null,
    warehouse_address varchar(200) not null,
    warehouse_zipcode varchar(10) not null,
    warehouse_status ENUM('NORMAL', 'INSPECTION', 'CLOSED') not null default 'NORMAL'
);

create table section(
    section_index Bigint auto_increment primary key,
    section_code int unique not null,
    section_name varchar(50) not null,
    section_capacity int not null,
    warehouse_index bigint not null
);

alter table section
    add constraint fk_warehouse_section
        foreign key (warehouse_index)
            references warehouse(warehouse_index)
            on delete cascade
            on update cascade ;