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
public class TestInvenDTO {
    private Long inven_index;
    private int inven_quantity;
    private LocalDateTime inbound_date;
    private LocalDateTime shipping_date;
    private Long section_index;
    private Long warehouse_index;
    private Long item_index;
    private Long detail_index;
}
