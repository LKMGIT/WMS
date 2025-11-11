package com.ssg.wms.announcement.domain;

import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 문의 게시판 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardRequestDTO {

    private Integer boardIndex;                 // 게시글 번호 (PK)
    private String bTitle;                      // 게시글 제목
    private String bContent;                    // 게시글 내용
    private LocalDateTime bCreateAt;            // 작성일
    private LocalDateTime bUpdateAt;            // 수정일
    private String bType;                       // 문의 유형
    private Integer bViews;                     // 조회수
    private Long userIndex;                     // 작성자번호

    // 댓글 목록 (조인용)
    private List<BoardCommentDTO> comments;
}
