package com.ssg.wms.inbound.domain;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InboundDetailDTO {

    // 입고 상세 기본 정보
    private Long detailIndex;                    // 입고 상세 번호 (PK)
    private Long inboundIndex;                      // 입고번호 (FK)
    private Long receivedQuantity;               // 입고 수량
    private LocalDateTime completeDate;             // 입고 일시
    private Integer warehouseIndex;                    // 창고번호
    private String sectionIndex;                   // 구역번호
}