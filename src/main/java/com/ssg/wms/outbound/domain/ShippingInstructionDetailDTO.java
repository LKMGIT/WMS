package com.ssg.wms.outbound.domain;

import com.ssg.wms.global.Enum.EnumStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShippingInstructionDetailDTO {
    private Long si_index;
    private Long or_index;
    private Long warehouse_index;
    private Long section_index;
    private Long user_index;
    private Long item_index;
    private String item_name;
    private int or_quantity;
    private EnumStatus si_waybill_status;
    private LocalDateTime approved_at;
}
