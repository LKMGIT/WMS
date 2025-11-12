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
public class OutboundResponseRegisterDTO {
    private Long admin_index;
    private Long or_index;
    private EnumStatus or_approval;
    private LocalDateTime updated_at;
    private String reject_detail;
}
