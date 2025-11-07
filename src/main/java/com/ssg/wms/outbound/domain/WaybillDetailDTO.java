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
public class WaybillDetailDTO {
    private Long waybill_index;
    private String waybill_id;
    private Long user_index;
    private Long warehouse_index;
    private String road_address;
    private String detail_address;
    private String or_zip_code;
    private String or_street_address;
    private String or_detailed_address;
    private Long item_index;
    private String or_quantity;
    private String item_name;
    private int item_volume;
    private Long vehicle_index;
    private String vehicle_id;
    private String vehicle_type;
    private String driver_name;
    private String driver_phone;
    private LocalDateTime created_at;
    private LocalDateTime completed_at;
    private EnumStatus waybill_status;
}
