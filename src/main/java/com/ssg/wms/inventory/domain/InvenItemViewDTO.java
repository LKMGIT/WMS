package com.ssg.wms.inventory.domain;

import com.ssg.wms.global.Enum.EnumStatus;
import lombok.Data;

@Data
public class InvenItemViewDTO {
    private Long invenIndex;
    private Long itemIndex;
    private String itemName;
    private String  itemCategory; // DB ENUM('HEALTH','BEAUTY','PERFUME','CARE','FOOD')
    private Long invenQuantity;
    private java.time.LocalDateTime inboundDate;
    private java.time.LocalDateTime shippingDate;
    private Long warehouseIndex;
    private Long sectionIndex;
}
