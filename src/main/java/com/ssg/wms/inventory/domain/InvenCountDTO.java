package com.ssg.wms.inventory.domain;

import lombok.Data;

@Data
public class InvenCountDTO {
    private Long countIndex;
    private Long invenIndex;
    private int invenQuantity;
    private int actualQuantity;
    private java.time.LocalDate updateAt;
}
