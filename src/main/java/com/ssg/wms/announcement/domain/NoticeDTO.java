package com.ssg.wms.announcement.domain;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 공지사항 DTO
 */
@Data
@NoArgsConstructor

public class NoticeDTO {

    private Integer noticeIndex;                // 공지 번호 (PK)
    private String nTitle;                      // 공지 제목
    private String nContent;                    // 공지 내용
    private LocalDateTime nCreateAt;            // 작성일
    private LocalDateTime nUpdateAt;            // 수정일
    private Integer nPriority;                  // 중요도 (0: 일반, 1: 중요)
    private Long adminIndex;                    // 관리자번호
}
