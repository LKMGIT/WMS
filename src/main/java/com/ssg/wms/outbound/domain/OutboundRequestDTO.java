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
public class OutboundRequestDTO {
    private Long or_index;
    private Long user_index;
    private Long item_index;
    private int or_quantity;
    private String or_name;
    private String or_phone;
    private String or_zip_code;
    private String or_street_address;
    private String or_detailed_address;
    private EnumStatus or_approval;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;
    private EnumStatus status;
    private EnumStatus or_dispatch_status;
    private LocalDateTime responded_at;
    private String reject_detail;
}
