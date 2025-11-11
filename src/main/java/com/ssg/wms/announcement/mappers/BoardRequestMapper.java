package com.ssg.wms.announcement.mappers;


import com.ssg.wms.announcement.domain.BoardCommentDTO;
import com.ssg.wms.announcement.domain.BoardRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardRequestMapper {

    // ============================================
    // 게시글 관련 메서드
    // ============================================

    /** 게시글 등록 */
    int insertBoard(BoardRequestDTO boardDTO);

    /** 게시글 목록 조회 */
    List<BoardRequestDTO> selectBoards(Map<String, Object> params);

    /** 게시글 상세 조회 */
    BoardRequestDTO selectBoard(@Param("board_index") Integer boardIndex);

    /** 게시글 조회수 증가 */
    int increaseViews(@Param("board_index") Integer boardIndex);

    /** 게시글 수정 */
    int updateBoard(BoardRequestDTO boardDTO);

    /** 게시글 삭제 */
    int deleteBoard(@Param("board_index") Integer boardIndex);


    /** 댓글 등록 */
    int insertComment(BoardCommentDTO commentDTO);

    /** 게시글의 댓글 목록 조회 */
    List<BoardCommentDTO> selectComments(@Param("board_index") Integer boardIndex);

    /** 댓글 삭제 */
    int deleteComment(@Param("comment_index") Integer commentIndex);
}
