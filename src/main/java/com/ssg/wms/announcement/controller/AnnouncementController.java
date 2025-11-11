package com.ssg.wms.announcement.controller;


import com.ssg.wms.announcement.domain.BoardCommentDTO;
import com.ssg.wms.announcement.domain.BoardRequestDTO;
import com.ssg.wms.announcement.domain.NoticeDTO;
import com.ssg.wms.announcement.domain.OneToOneRequestDTO;
import com.ssg.wms.announcement.service.BoardRequestService;
import com.ssg.wms.announcement.service.NoticeService;
import com.ssg.wms.announcement.service.OneToOneRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/api")
public class AnnouncementController {

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private OneToOneRequestService oneToOneRequestService;

    @Autowired
    private BoardRequestService boardRequestService;

    /** 공지사항 목록 조회 */
    @GetMapping("/notices")
    @ResponseBody
    public ResponseEntity<List<NoticeDTO>> getNotices(
            @RequestParam(required = false) String keyword) {

        List<NoticeDTO> notices = noticeService.getNotices(keyword);
        return ResponseEntity.ok(notices);
    }

    /** 공지사항 상세 조회 */
    @GetMapping("/notices/{notice_index}")
    @ResponseBody
    public ResponseEntity<NoticeDTO> getNoticeDetail(
            @PathVariable("notice_index") Integer noticeIndex) {

        NoticeDTO notice = noticeService.getNoticeDetail(noticeIndex);

        if (notice == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(notice);
    }

    /** 공지사항 등록 (관리자) */
    @PostMapping("/admin/notices")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerNotice(
            @RequestBody NoticeDTO noticeDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            Integer noticeIndex = noticeService.registerNotice(noticeDTO, adminId);

            response.put("success", true);
            response.put("message", "공지사항이 등록되었습니다.");
            response.put("noticeIndex", noticeIndex);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "공지사항 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 공지사항 수정 (관리자)  */
    @PutMapping("/admin/notices")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateNotice(
            @RequestBody NoticeDTO noticeDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = noticeService.updateNotice(noticeDTO, adminId);

            if (result) {
                response.put("success", true);
                response.put("message", "공지사항이 수정되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "공지사항 수정에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "공지사항 수정 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 공지사항 삭제 (관리자) */
    @DeleteMapping("/admin/notices/{notice_index}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteNotice(
            @PathVariable("notice_index") Integer noticeIndex,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = noticeService.deleteNotice(noticeIndex, adminId);

            if (result) {
                response.put("success", true);
                response.put("message", "공지사항이 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "공지사항 삭제에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "공지사항 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 1:1 문의 등록 */
    @PostMapping("/one-to-one")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerOneToOneRequest(
            @RequestBody OneToOneRequestDTO requestDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            Integer requestIndex = oneToOneRequestService.registerRequest(requestDTO, userId);

            response.put("success", true);
            response.put("message", "1:1 문의가 등록되었습니다.");
            response.put("requestIndex", requestIndex);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "1:1 문의 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 내 1:1 문의 목록 조회 */
    @GetMapping("/one-to-one/my")
    @ResponseBody
    public ResponseEntity<List<OneToOneRequestDTO>> getMyOneToOneRequests(
            @RequestParam(required = false) String keyword,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<OneToOneRequestDTO> requests = oneToOneRequestService.getMyRequests(userId, keyword);
        return ResponseEntity.ok(requests);
    }

    /**  1:1 문의 상세 조회 */
    @GetMapping("/one-to-one/{request_index}")
    @ResponseBody
    public ResponseEntity<OneToOneRequestDTO> getOneToOneRequestDetail(
            @PathVariable("request_index") Integer requestIndex,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        OneToOneRequestDTO request = oneToOneRequestService.getRequestDetail(requestIndex, userId);

        if (request == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        return ResponseEntity.ok(request);
    }

    /** 1:1 문의 수정 */
    @PutMapping("/one-to-one")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateOneToOneRequest(
            @RequestBody OneToOneRequestDTO requestDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = oneToOneRequestService.updateRequest(requestDTO, userId);

            if (result) {
                response.put("success", true);
                response.put("message", "1:1 문의가 수정되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "1:1 문의 수정에 실패했습니다. (답변 완료된 문의는 수정할 수 없습니다)");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "1:1 문의 수정 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 1:1 문의 삭제 */
    @DeleteMapping("/one-to-one/{request_index}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteOneToOneRequest(
            @PathVariable("request_index") Integer requestIndex,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = oneToOneRequestService.deleteRequest(requestIndex, userId);

            if (result) {
                response.put("success", true);
                response.put("message", "1:1 문의가 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "1:1 문의 삭제에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "1:1 문의 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 관리자용 1:1 문의 목록 조회 */
    @GetMapping("/admin/one-to-one/list")
    @ResponseBody
    public ResponseEntity<List<OneToOneRequestDTO>> getAdminOneToOneRequests(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            HttpSession session) {

        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<OneToOneRequestDTO> requests = oneToOneRequestService.getAdminRequests(keyword, status);
        return ResponseEntity.ok(requests);
    }

    /** 1:1 문의 답변 등록/수정 (관리자) */
    @PutMapping("/admin/one-to-one/{request_index}/reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> replyToOneToOneRequest(
            @PathVariable("request_index") Integer requestIndex,
            @RequestParam String response,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                result.put("success", false);
                result.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
            }

            boolean success = oneToOneRequestService.replyToRequest(requestIndex, response, adminId);

            if (success) {
                result.put("success", true);
                result.put("message", "답변이 등록되었습니다.");
                return ResponseEntity.ok(result);
            } else {
                result.put("success", false);
                result.put("message", "답변 등록에 실패했습니다.");
                return ResponseEntity.badRequest().body(result);
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "답변 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }

    /** 관리자의 1:1 문의 삭제 */
    @DeleteMapping("/admin/one-to-one/{request_index}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteAdminOneToOneRequest(
            @PathVariable("request_index") Integer requestIndex,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = oneToOneRequestService.deleteAdminRequest(requestIndex, adminId);

            if (result) {
                response.put("success", true);
                response.put("message", "1:1 문의가 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "1:1 문의 삭제에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "1:1 문의 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 게시글 목록 조회 */
    @GetMapping("/board")
    @ResponseBody
    public ResponseEntity<List<BoardRequestDTO>> getBoards(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String type) {

        List<BoardRequestDTO> boards = boardRequestService.getBoards(keyword, type);
        return ResponseEntity.ok(boards);
    }

    /** 게시글 상세 조회 (조회수 증가 포함) */
    @GetMapping("/board/{board_index}")
    @ResponseBody
    public ResponseEntity<BoardRequestDTO> getBoardDetail(
            @PathVariable("board_index") Integer boardIndex) {

        BoardRequestDTO board = boardRequestService.getBoardDetail(boardIndex);

        if (board == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(board);
    }

    /** 게시글 등록 */
    @PostMapping("/board")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerBoard(
            @RequestBody BoardRequestDTO boardDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            Integer boardIndex = boardRequestService.registerBoard(boardDTO, userId);

            response.put("success", true);
            response.put("message", "게시글이 등록되었습니다.");
            response.put("boardIndex", boardIndex);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "게시글 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 게시글 수정 */
    @PutMapping("/board")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateBoard(
            @RequestBody BoardRequestDTO boardDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = boardRequestService.updateBoard(boardDTO, userId);

            if (result) {
                response.put("success", true);
                response.put("message", "게시글이 수정되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "게시글 수정에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "게시글 수정 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 게시글 삭제 */
    @DeleteMapping("/board/{board_index}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteBoard(
            @PathVariable("board_index") Integer boardIndex,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = boardRequestService.deleteBoard(boardIndex, userId);

            if (result) {
                response.put("success", true);
                response.put("message", "게시글이 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "게시글 삭제에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "게시글 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 댓글 등록 (사용자 또는 관리자)  */
    @PostMapping("/board/{board_index}/comments")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerComment(
            @PathVariable("board_index") Integer boardIndex,
            @RequestBody BoardCommentDTO commentDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            Long adminId = (Long) session.getAttribute("adminId");

            if (userId == null && adminId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            commentDTO.setBoardIndex(boardIndex);
            Integer commentIndex = boardRequestService.registerComment(commentDTO, userId, adminId);

            response.put("success", true);
            response.put("message", "댓글이 등록되었습니다.");
            response.put("commentIndex", commentIndex);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "댓글 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 댓글 삭제 (작성자 또는 관리자) */
    @DeleteMapping("/board/comments/{comment_index}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteComment(
            @PathVariable("comment_index") Integer commentIndex,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            Long adminId = (Long) session.getAttribute("adminId");

            if (userId == null && adminId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = boardRequestService.deleteComment(commentIndex, userId, adminId);

            if (result) {
                response.put("success", true);
                response.put("message", "댓글이 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "댓글 삭제에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "댓글 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 공지사항 목록 화면 */
    @GetMapping("/notices/list")
    public String showNoticeList() {
        return "notice/list";
    }

    /** 공지사항 상세 화면 */
    @GetMapping("/notices/detail/{notice_index}")
    public String showNoticeDetail(@PathVariable("notice_index") Integer noticeIndex, Model model) {
        model.addAttribute("noticeIndex", noticeIndex);
        return "notice/detail";
    }

    /** 1:1 문의 등록 화면 */
    @GetMapping("/one-to-one/register")
    public String showOneToOneRegisterForm() {
        return "onetoone/register";
    }

    /** 내 1:1 문의 목록 화면 */
    @GetMapping("/one-to-one/my/list")
    public String showMyOneToOneList() {
        return "onetoone/myList";
    }

    /** 1:1 문의 상세 화면 */
    @GetMapping("/one-to-one/detail/{request_index}")
    public String showOneToOneDetail(@PathVariable("request_index") Integer requestIndex, Model model) {
        model.addAttribute("requestIndex", requestIndex);
        return "onetoone/detail";
    }

    /** 게시판 목록 화면 */
    @GetMapping("/board/list")
    public String showBoardList() {
        return "board/list";
    }

    /** 게시판 상세 화면 */
    @GetMapping("/board/detail/{board_index}")
    public String showBoardDetail(@PathVariable("board_index") Integer boardIndex, Model model) {
        model.addAttribute("boardIndex", boardIndex);
        return "board/detail";
    }

    /** 게시판 작성 화면 */
    @GetMapping("/board/register")
    public String showBoardRegisterForm() {
        return "board/register";
    }

    /** 관리자 공지사항 관리 화면 */
    @GetMapping("/admin/notices")
    public String showAdminNotices() {
        return "admin/notice/list";
    }

    /** 관리자 1:1 문의 관리 화면 */
    @GetMapping("/admin/one-to-one")
    public String showAdminOneToOne() {
        return "admin/onetoone/list";
    }
}
