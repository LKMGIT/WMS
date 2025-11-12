package com.ssg.wms.inventory.domain;

import lombok.Data;

@Data
public class InvenDTO {

    private Long invenIndex;
    private int invenQuantity;
    private java.time.LocalDateTime inboundDate;
    private java.time.LocalDateTime shippingDate;
    private Long sectionIndex;
    private Long warehouseIndex;
    private Long itemIndex;
    private Long detailInbound; //입고 번호 
    private Long detailOutbound; //출고 번호

}
