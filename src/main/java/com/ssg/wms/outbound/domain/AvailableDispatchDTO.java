package com.ssg.wms.outbound.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AvailableDispatchDTO {
    private String driver_name;
    private Long vehicle_index;
    private String vehicle_id;
    private String vehicle_type;
    private int vehicle_volume; // 수용 가능한 부피를 계산해서 보낼 예정
}
