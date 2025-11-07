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
public class ShippingInstructionDTO {
    private Long si_index;
    private Long dispatch_index;
    private Long admin_index;
    private LocalDateTime approved_at;
    private Long warehouse_index;
    private Long section_index;
    private EnumStatus si_waybill_status;
    private EnumStatus status;
}
