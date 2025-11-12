package com.ssg.wms.inbound.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 입고 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InboundRequestDTO {

    // 입고 요청 기본 정보
    private Long inboundIndex;                      // 입고 번호 (PK)
    private Integer inboundRequestQuantity;         // 요청 수량
    private LocalDateTime inboundRequestDate;       // 요청 일자
    private LocalDate plannedReceiveDate;           // 희망 입고 날짜
    private String approvalStatus;                  // 승인 상태 (PENDING, APPROVED, REJECTED, CANCELED)
    private LocalDateTime approveDate;              // 승인 일시
    private String cancelReason;                    // 취소 사유
    private LocalDateTime updatedDate;              // 수정 일시
    private Long userIndex;                         // 유저번호 (FK)
    private Long warehouseIndex;                    // 창고번호 (FK)

    // 입고 상세 리스트 (조인용)
    private List<InboundDetailDTO> details;

}
