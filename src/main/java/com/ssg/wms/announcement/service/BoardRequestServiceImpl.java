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
    public Integer registerBoard(BoardRequestDTO boardDTO, Long userId) {
        boardDTO.setUserIndex(userId);
        boardRequestMapper.insertBoard(boardDTO);
        return boardDTO.getBoardIndex();
    }

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

    @Override
    public boolean updateBoard(BoardRequestDTO boardDTO, Long userId) {
        BoardRequestDTO existing = boardRequestMapper.selectBoard(boardDTO.getBoardIndex());
        if (existing == null || !existing.getUserIndex().equals(userId)) {
            return false;
        }

        return boardRequestMapper.updateBoard(boardDTO) > 0;
    }

    @Override
    public boolean deleteBoard(Integer boardIndex, Long userId) {
        BoardRequestDTO existing = boardRequestMapper.selectBoard(boardIndex);
        if (existing == null) {
            return false;
        }

        // 작성자 본인이거나 관리자(userId가 null)만 삭제 가능
        if (userId != null && !existing.getUserIndex().equals(userId)) {
            return false;
        }

        return boardRequestMapper.deleteBoard(boardIndex) > 0;
    }


    // 댓글 관련 메서드
    @Override
    public Integer registerComment(BoardCommentDTO commentDTO, Long userId, Long adminId) {
        commentDTO.setUserIndex(userId);
        commentDTO.setAdminIndex(adminId);
        boardRequestMapper.insertComment(commentDTO);
        return commentDTO.getCommentIndex();
    }

    @Override
    public List<BoardCommentDTO> getComments(Integer boardIndex) {
        return boardRequestMapper.selectComments(boardIndex);
    }

    @Override
    public boolean deleteComment(Integer commentIndex, Long userId, Long adminId) {
        return boardRequestMapper.deleteComment(commentIndex) > 0;
    }
}
