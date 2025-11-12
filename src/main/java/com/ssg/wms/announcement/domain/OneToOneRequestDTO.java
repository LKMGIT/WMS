package com.ssg.wms.announcement.domain;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 1:1 문의 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OneToOneRequestDTO {

    private Integer requestIndex;               // 1:1 문의 번호 (PK)
    private String rTitle;                      // 문의 제목
    private String rContent;                    // 문의 내용
    private LocalDateTime rCreateAt;            // 작성일
    private LocalDateTime rUpdateAt;            // 수정일
    private String rStatus;                     // 답변 상태 (PENDING, ANSWERED)
    private String rType;                       // 문의 유형
    private String rResponse;                   // 관리자 답변
    private Long userIndex;                     // 유저번호
    private Long adminIndex;                    // 답변한 관리자번호
}
