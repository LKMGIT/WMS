use wms;


create table inventory(
    inven_index BIGINT primary key auto_increment not null,
    inven_quantity int not null,
    inbound_date DATETIME null,
    shipping_date DATETIME null,
    section_id Bigint not null,
    warehouse_index Bigint not null,
    item_index Bigint not null,
    detail_index int not null
);