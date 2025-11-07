package com.ssg.wms.outbound.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DispatchDetailDTO {
    private Long dispatch_index;
    private LocalDateTime dispatch_date;
    private Long or_index;
    private Long vehicle_index;
    private String vehicle_id;
    private String driver_name;
    private String vehicle_type;
}
