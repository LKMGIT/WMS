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
public class VehicleDTO {
    private Long vehicle_index;
    private String vehicle_name;
    private String vehicle_id;
    private int vehicle_volume;
    private EnumStatus vehicle_status;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;
    private EnumStatus status;
    private String driver_name;
    private String driver_phone;
}
