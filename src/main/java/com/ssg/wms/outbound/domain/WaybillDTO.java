package com.ssg.wms.outbound.domain;

import com.ssg.wms.global.Enum.EnumStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WaybillDTO {
    private Long waybill_index;
    private String waybill_id;
    private Long si_index;
    private LocalDateTime created_at;
    private LocalDateTime completed_at;
    private EnumStatus waybill_status;
}
