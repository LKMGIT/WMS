use wms;

create table invencount(
    count_index Bigint primary key not null auto_increment,
    inven_index BIGINT not null,
    inven_quantity int not null,
    inevn_change int not null,
    actual_quantity int not null,
    updateAt DATETIME
);