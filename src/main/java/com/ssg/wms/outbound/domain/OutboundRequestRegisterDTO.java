package com.ssg.wms.outbound.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OutboundRequestRegisterDTO {
    private Long or_index;
    private Long user_index;
    private Long item_index;
    private int or_quantity;
    private String or_name;
    private String or_phone;
    private String or_zip_code;
    private String or_street_address;
    private String or_detailed_address;
}
