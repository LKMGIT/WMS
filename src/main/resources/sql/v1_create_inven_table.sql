use wms;

DROP TABLE IF EXISTS inventory;


-- INVENTORY: (item, warehouse, section) 조합은 단 한 행만!
CREATE TABLE inventory (
                           inven_index      BIGINT       NOT NULL AUTO_INCREMENT,
                           item_index       BIGINT       NOT NULL,
                           warehouse_index  BIGINT       NOT NULL,
                           section_index    BIGINT       NOT NULL,
                           inven_quantity   INT          NOT NULL,
                           inbound_date     DATETIME     NULL,
                           shipping_date    DATETIME     NULL,
                           detail_inbound   BIGINT       NULL,
                           detail_outbound  BIGINT       NULL,
                           PRIMARY KEY (inven_index),

    -- 같은 아이템/창고/구역은 1행만 유지 (중복 방지)
                           UNIQUE KEY uq_inventory_item_wh_sec (item_index, warehouse_index, section_index),

    -- 조회용 인덱스
                           KEY idx_inventory_item (item_index),
                           KEY idx_inventory_wh   (warehouse_index),
                           KEY idx_inventory_sec  (section_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE inventory
    ADD UNIQUE KEY uq_inventory_item_wh_sec (item_index, warehouse_index, section_index);