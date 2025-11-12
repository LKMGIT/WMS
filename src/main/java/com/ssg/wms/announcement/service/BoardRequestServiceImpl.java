package com.ssg.wms.announcement.service;

import com.ssg.wms.announcement.domain.BoardCommentDTO;
import com.ssg.wms.announcement.domain.BoardRequestDTO;
import com.ssg.wms.announcement.mappers.BoardRequestMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class BoardRequestServiceImpl implements BoardRequestService {

    @Autowired
    private BoardRequestMapper boardRequestMapper;

    @Override
    public List<BoardRequestDTO> getBoards(String keyword, String type) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("type", type);
        return boardRequestMapper.selectBoards(params);
    }

    @Override
    public BoardRequestDTO getBoardDetail(Integer boardIndex) {
        // 조회수 증가
        boardRequestMapper.increaseViews(boardIndex);

        // 게시글 조회
        BoardRequestDTO board = boardRequestMapper.selectBoard(boardIndex);

        // 댓글 목록 조회
        if (board != null) {
            List<BoardCommentDTO> comments = boardRequestMapper.selectComments(boardIndex);
            board.setComments(comments);
        }

        return board;
    }

    // 관리자 전용 게시글 삭제
    @Override
    public boolean deleteBoardByAdmin(Integer boardIndex, Long adminId) {
        BoardRequestDTO existing = boardRequestMapper.selectBoard(boardIndex);
        if (existing == null) {
            return false;
        }

        // 관리자는 권한 체크 없이 삭제 가능
        return boardRequestMapper.deleteBoard(boardIndex) > 0;
    }


    // 댓글 관련 메서드 (관리자 전용으로 수정)
    @Override
    public Integer registerComment(BoardCommentDTO commentDTO, Long adminId) {
        commentDTO.setUserIndex(null);
        commentDTO.setAdminIndex(adminId);
        boardRequestMapper.insertComment(commentDTO);
        return commentDTO.getCommentIndex();
    }

    @Override
    public List<BoardCommentDTO> getComments(Integer boardIndex) {
        return boardRequestMapper.selectComments(boardIndex);
    }

    @Override
    public boolean deleteComment(Integer commentIndex, Long adminId) {
        return boardRequestMapper.deleteComment(commentIndex) > 0;
    }
}