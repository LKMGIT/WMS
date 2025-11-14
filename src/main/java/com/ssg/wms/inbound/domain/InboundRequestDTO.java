package com.ssg.wms.inbound.domain;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class InboundRequestDTO {

    // 입고 요청 기본 정보
    private Long inboundIndex;                      // 입고 번호 (PK)
    private Long inboundRequestQuantity;         // 요청 수량
    private LocalDateTime inboundRequestDate;       // 요청 일자
    private LocalDate plannedReceiveDate;           // 희망 입고 날짜
    private String approvalStatus;                  // 승인 상태
    private LocalDateTime approveDate;              // 승인 일시
    private String cancelReason;                    // 취소 사유
    private LocalDateTime updatedDate;              // 수정 일시
    private Long userIndex;                         // 유저번호 (FK)
    private Integer warehouseIndex;                     // 창고번호 (FK)
    private Long itemIndex;                        // 아이템 번호(FK)

    // 입고 상세 리스트 (조인용)
    private List<InboundDetailDTO> details;

    private Long detailCount;            // 상세 개수 (COUNT 결과)
    private Long totalReceivedQuantity;     // 총 입고 수량 (SUM 결과)
}