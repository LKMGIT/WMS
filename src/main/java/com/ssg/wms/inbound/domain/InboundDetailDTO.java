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
    private Long requestIndex;                      // 요청 번호
    private String qrCode;                          // QR 코드 값
    private Long receivedQuantity;               // 입고 수량
    private LocalDateTime completeDate;             // 입고 일시
    private Long inboundIndex;                      // 입고번호
    private Integer warehouse_index;                    // 창고번호
    private String section_index;                   // 구역번호

}
