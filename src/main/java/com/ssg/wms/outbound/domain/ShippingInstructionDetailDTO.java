package com.ssg.wms.outbound.domain;

import com.ssg.wms.global.Enum.EnumStatus;

import java.time.LocalDateTime;

public class ShippingInstructionDetailDTO {
    private Long si_index;
    private Long or_index;
    private LocalDateTime created_at;
    private Long warehouse_index;
    private Long section_index;
    private Long user_index;
    private Long item_index;
    private String item_name;
    private int or_quantity;
    private EnumStatus si_waybill_status;
    private LocalDateTime approved_at;
}
