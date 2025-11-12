use wms;

create table items(
    item_index Bigint auto_increment not NULL primary key,
    item_name varchar(255) not null,
    item_price int not null,
    item_volume int not null,
    item_category ENUM('HEALTH','BEAUTY','PERFUME','CARE','FOOD') NOT NULL,
    item_img LONGBLOB  null,
    inbound_index Bigint not null
);