package com.ssg.wms.announcement.service;

import com.ssg.wms.announcement.domain.BoardCommentDTO;
import com.ssg.wms.announcement.domain.BoardRequestDTO;

import java.util.List;

public interface BoardRequestService {

    /** 게시글 목록 조회 */
    List<BoardRequestDTO> getBoards(String keyword, String type);

    /** 게시글 상세 조회 (조회수 증가 포함) */
    BoardRequestDTO getBoardDetail(Integer boardIndex);

    // 관리자 전용 게시글 삭제 추가
    /** 게시글 삭제 (관리자) */
    boolean deleteBoardByAdmin(Integer boardIndex, Long adminId);


    /** 댓글 등록 (관리자) */
    Integer registerComment(BoardCommentDTO commentDTO, Long adminId);

    /** 게시글의 댓글 목록 조회 */
    List<BoardCommentDTO> getComments(Integer boardIndex);

    /** 댓글 삭제 (관리자) */
    boolean deleteComment(Integer commentIndex, Long adminId);
}