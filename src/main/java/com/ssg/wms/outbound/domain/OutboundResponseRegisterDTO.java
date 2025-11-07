package com.ssg.wms.outbound.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OutboundResponseRegisterDTO {
    private Long admin_index;
    private Long or_index;
    private String rejected_detail;
}
