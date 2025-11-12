use wms;

DROP TABLE IF EXISTS inven_count;
-- INVEN_COUNT: inventory의 스냅샷(FK로 정확히 연결)
CREATE TABLE inven_count (
                             count_index      BIGINT       NOT NULL AUTO_INCREMENT,
                             inven_index      BIGINT       NOT NULL,
                             inven_quantity   INT          NOT NULL,
                             actual_quantity  INT          NOT NULL,
                             count_updateAt   DATETIME     NOT NULL,
                             PRIMARY KEY (count_index),

                             KEY idx_inven_count_inven (inven_index),
                             CONSTRAINT fk_inven_count_inventory
                                 FOREIGN KEY (inven_index) REFERENCES inventory(inven_index)
                                     ON DELETE CASCADE
                                     ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;