package com.ssg.wms.quotation.controller;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.quotation.domain.QuotationCommentDTO;
import com.ssg.wms.quotation.domain.QuotationDetailDTO;
import com.ssg.wms.quotation.domain.QuotationRequestDTO;
import com.ssg.wms.quotation.domain.QuotationSearchDTO;
import com.ssg.wms.quotation.service.QuotationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Log4j2
@RestController
@RequestMapping("/api/quotation")
@RequiredArgsConstructor
public class QuotationMemberController {

    private final QuotationService quotationService;

    /**
     * 견적신청 목록 조회 (회원) - GET (ReplyController.list 패턴)
     */
    @GetMapping("/request")
    public Map<String, Object> getQuotationRequests(
            @ModelAttribute Criteria criteria,
            @ModelAttribute QuotationSearchDTO quotationSearchDTO) {

        List<QuotationRequestDTO> list = quotationService.getQuotationRequestList(criteria, quotationSearchDTO);
        int total = quotationService.getQuotationRequestTotalCount(quotationSearchDTO);

        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("pageDTO", pageDTO);

        return map;
    }

    /**
     * 견적신청 등록 (회원) - POST (BoardController.update/delete 패턴 적용)
     * (참고: Service가 boolean을 반환하지만, BoardController 패턴을 따르기 위해 DTO를 반환)
     * (MyBatis의 useGeneratedKeys=true가 DTO에 ID를 채워줘야 함)
     */
    @PostMapping("/request")
    public ResponseEntity<QuotationRequestDTO> registerQuotationRequest(
            // @SessionAttribute("loginUserId") Long userId,
            @RequestBody QuotationRequestDTO quotationRequestDTO
    ) {
        // 테스트용 ID
        Long userId = 1L;

        quotationRequestDTO.setUser_index(userId);
        boolean result = quotationService.registerQuotationRequest(quotationRequestDTO);

        if (!result) {
            return ResponseEntity.badRequest().build();
        }

        QuotationRequestDTO createdDTO = (QuotationRequestDTO) quotationService.getQuotationRequestById(quotationRequestDTO.getQrequest_index());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdDTO);
    }

    /**
     * 견적신청 상세 조회 (회원) - GET (BoardController.get 패턴)
     */
    @GetMapping("/request/{qrequest_index}")
    public ResponseEntity<QuotationDetailDTO> getQuotationRequest(
            @PathVariable("qrequest_index") Long qrequest_index,
            // @SessionAttribute("loginUserId") Long userId,
            @ModelAttribute QuotationSearchDTO quotationSearchDTO
    ) {
        // 테스트용 ID
        Long userId = 1L;

        QuotationDetailDTO detailDTO = quotationService.getQuotationRequestDetailById(quotationSearchDTO, qrequest_index);

        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(detailDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to access quotation {}", userId, qrequest_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build(); // 403 Forbidden
        }

        return ResponseEntity.ok(detailDTO);
    }

    /**
     * 견적신청 수정 (회원) - PUT (BoardController.update 패턴)
     */
    @PutMapping("/request/{qrequest_index}")
    public ResponseEntity<QuotationRequestDTO> modifyQuotationRequest(
            @PathVariable("qrequest_index") Long qrequest_index,
            // @SessionAttribute("loginUserId") Long userId,
            @RequestBody QuotationRequestDTO quotationRequestDTO
    ) {
        // 테스트용 ID
        Long userId = 1L;

        // 1. GET (검증)
        QuotationRequestDTO originalDTO = quotationService.getQuotationRequestById(qrequest_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to modify quotation {}", userId, qrequest_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build(); // 403 Forbidden
        }

        // 3. CUD
        quotationRequestDTO.setQrequest_index(qrequest_index);
        quotationRequestDTO.setUser_index(userId);
        boolean result = quotationService.modifyQuotationRequest(quotationRequestDTO);

        if (!result) {
            // 검증은 통과했는데 수정이 실패한 경우 (e.g., 동시성 문제)
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        QuotationRequestDTO updatedDTO = quotationService.getQuotationRequestById(qrequest_index);
        return ResponseEntity.ok(updatedDTO);
    }


    /**
     * 견적신청 삭제 (회원) - PUT (Soft Delete) (BoardController.delete 패턴)
     */
    @PutMapping("/request/{qrequest_index}:delete")
    public ResponseEntity<QuotationRequestDTO> removeQuotationRequest(
            // @SessionAttribute("loginUserId") Long userId,
            @PathVariable("qrequest_index") Long qrequest_index
    ) {
        // 테스트용 ID
        Long userId = 1L;

        // 1. GET (검증)
        QuotationRequestDTO originalDTO = quotationService.getQuotationRequestById(qrequest_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to delete quotation {}", userId, qrequest_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build(); // 403 Forbidden
        }
        // ▲▲▲ 검증 끝 ▲▲▲

        // 3. CUD
        boolean result = quotationService.removeQuotationRequest(qrequest_index);

        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        QuotationRequestDTO deletedDTO = quotationService.getQuotationRequestById(qrequest_index);
        return ResponseEntity.ok(deletedDTO);
    }

    // --- 견적 댓글 (Member) ---

    /**
     * 견적댓글 목록 조회 (회원) - GET
     */
    @GetMapping("/comment/{qrequest_index}")
    public Map<String, Object> getQuotationComments(
            @PathVariable("qrequest_index") Long qrequest_index,
            @ModelAttribute Criteria criteria) {

        List<QuotationCommentDTO> list = quotationService.getQuotationCommentList(criteria, qrequest_index);
        int total = quotationService.getQuotationCommentTotalCount(qrequest_index);
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("pageDTO", pageDTO);

        return map;
    }

    /**
     * 견적댓글 등록 (회원) - POST
     * (참고: 댓글은 등록 후 re-fetch 없이 DTO를 반환합니다. (BoardController.register 패턴))
     * (Service.csv 명세상 registerQuotationComment는 boolean 반환, BoardController는 DTO 반환.
     * BoardController 패턴을 따르기 위해 useGeneratedKeys를 가정하고 입력 DTO를 반환합니다.)
     */
    @PostMapping("/comment/{qrequest_index}")
    public ResponseEntity<QuotationCommentDTO> registerQuotationComment(
            @PathVariable("qrequest_index") Long qrequest_index,
            // @SessionAttribute("loginUserId") Long userId,
            @RequestBody QuotationCommentDTO quotationCommentDTO
    ) {
        //테스트용 ID
        Long userId = 1L;

        quotationCommentDTO.setQrequest_index(qrequest_index);
        quotationCommentDTO.setUser_index(userId);
        quotationCommentDTO.setWriter_type(EnumStatus.USER);

        boolean result = quotationService.registerQuotationComment(quotationCommentDTO);

        if (!result) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(quotationCommentDTO);
    }

    /**
     * 견적댓글 수정 (회원) - PUT
     */
    @PutMapping("/comment/{qrequest_index}/{qcomment_index}")
    public ResponseEntity<QuotationCommentDTO> modifyQuotationComment(
            @PathVariable("qrequest_index") Long qrequest_index,
            @PathVariable("qcomment_index") Long qcomment_index,
            // @SessionAttribute("loginUserId") Long userId,
            @RequestBody QuotationCommentDTO quotationCommentDTO
    ) {
        //테스트용 ID
        Long userId = 1L;

        // 1. GET (검증)
        QuotationCommentDTO originalDTO = quotationService.getQuotationCommentById(qcomment_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to delete quotation {}", userId, qrequest_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build(); // 403 Forbidden
        }

        quotationCommentDTO.setQcomment_index(qcomment_index);
        quotationCommentDTO.setUser_index(userId);

        boolean result = quotationService.modifyQuotationComment(quotationCommentDTO);

        if (!result) {
            return ResponseEntity.notFound().build();
        }
        QuotationCommentDTO updatedDTO = quotationService.getQuotationCommentById(qcomment_index);
        return ResponseEntity.ok(updatedDTO);
    }

    /**
     * 견적댓글 삭제 (회원) - PUT (Soft Delete)
     */
    @PutMapping("/comment/{qrequest_index}/{qcomment_index}:delete")
    public ResponseEntity<QuotationCommentDTO> removeQuotationComment( // 삭제는 boolean Map 반환
                                                                       // @SessionAttribute("loginUserId") Long userId,
                                                                        @PathVariable("qrequest_index") Long qrequest_index,
                                                                        @PathVariable("qcomment_index") Long qcomment_index
    ) {
        //테스트용 ID
        Long userId = 1L;

        // 1. GET (검증)
        QuotationCommentDTO originalDTO = quotationService.getQuotationCommentById(qcomment_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to delete qcomment {}", userId, qcomment_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build(); // 403 Forbidden
        }

        // 3. CUD
        boolean result = quotationService.removeQuotationComment(qcomment_index);
        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        QuotationCommentDTO deletedDTO = quotationService.getQuotationCommentById(qcomment_index);
        return ResponseEntity.ok(deletedDTO);
    }
}