package com.ssg.wms.inbound.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor

public class InboundDTO {
    private Long inbound_index;
    private int inbound_request_quantity;
    private LocalDateTime inbound_request_date;
    private LocalDateTime planned_receive_date;
    private String approval_status;
    private LocalDateTime approval_date;
    private String cancel_reason;
    private LocalDateTime updated_date;
    private Long user_index;
    private int warehouse_index;
}
