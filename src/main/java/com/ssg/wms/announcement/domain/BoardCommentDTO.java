package com.ssg.wms.announcement.domain;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 문의 게시판 댓글 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardCommentDTO {

    private Integer commentIndex;               // 댓글 번호 (PK)
    private Integer boardIndex;                 // 게시글 번호 (FK)
    private String cContent;                    // 댓글 내용
    private LocalDateTime cCreateAt;            // 작성일
    private Long userIndex;                     // 작성자번호 (사용자)
    private Long adminIndex;                    // 작성자번호 (관리자)
}
