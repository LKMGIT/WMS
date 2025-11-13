package com.ssg.wms.quotation.controller;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.quotation.domain.*;
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
@RequestMapping("/api/admin/quotation")
@RequiredArgsConstructor
public class QuotationAdminController {

    private final QuotationService quotationService;

    /**
     * 견적신청 목록 조회 (관리자) - GET
     */
    @GetMapping("/request")
    public Map<String, Object> getQuotationRequests(
            @ModelAttribute Criteria criteria,
            @ModelAttribute QuotationSearchDTO quotationSearchDTO) {
        log.info(criteria.getPageNum());
        List<QuotationRequestDTO> list = quotationService.getQuotationRequestList(criteria, quotationSearchDTO);
        int total = quotationService.getQuotationRequestTotalCount(quotationSearchDTO);

        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("pageDTO", pageDTO);

        return map;
    }

    /**
     * 견적신청 상세 조회 (관리자) - GET
     */
    @GetMapping("/request/{qrequest_index}")
    public ResponseEntity<QuotationDetailDTO> getQuotationRequest(
            @PathVariable("qrequest_index") Long qrequest_index,
            @ModelAttribute QuotationSearchDTO quotationSearchDTO,
            @SessionAttribute("loginAdminIndex") Long adminIndex
    ) {

        QuotationDetailDTO detailDTO = quotationService.getQuotationRequestDetailById(quotationSearchDTO, qrequest_index);
        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(detailDTO);
    }

    /**
     * 견적답변 등록 (관리자) - POST
     */
    @PostMapping("/request/{qrequest_index}/response")
    public ResponseEntity<QuotationResponseDTO> registerQuotationResponse(
            @PathVariable("qrequest_index") Long qrequest_index,
            @RequestBody QuotationResponseDTO quotationResponseDTO,
            @SessionAttribute("loginAdminIndex") Long adminIndex
    ) {

        quotationResponseDTO.setQrequest_index(qrequest_index);
        quotationResponseDTO.setAdmin_index(adminIndex);

        boolean result = quotationService.registerQuotationResponse(quotationResponseDTO);

        if (!result) {
            return ResponseEntity.badRequest().build();
        }

        // 등록 성공 시, Service.csv 명세에 따라 다시 조회
        QuotationResponseDTO createdResponse = quotationService.getQuotationResponseById(qrequest_index);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdResponse);
    }

    /**
     * 견적답변 수정 (관리자) - PUT
     */
    @PutMapping("/response/{qresponse_index}")
    public ResponseEntity<QuotationResponseDTO> modifyQuotationResponse(
            @PathVariable("qresponse_index") Long qresponse_index,
            @RequestBody QuotationResponseDTO quotationResponseDTO,
            @SessionAttribute("loginAdminIndex") Long adminIndex
    ) {

        quotationResponseDTO.setQresponse_index(qresponse_index);
        quotationResponseDTO.setAdmin_index(adminIndex); // 서비스단에서 검증용

        boolean result = quotationService.modifyQuotationResponse(quotationResponseDTO);

        if (!result) {
            return ResponseEntity.notFound().build();
        }

        QuotationResponseDTO updatedDTO = quotationService.getQuotationResponse(qresponse_index);
        return ResponseEntity.ok(updatedDTO);
    }

    /**
     * 견적답변 삭제 (관리자) - PUT (Soft Delete)
     */
    @PutMapping("/response/{qresponse_index}:delete")
    public ResponseEntity<QuotationResponseDTO> removeQuotationResponse( // 삭제는 boolean Map 반환
                                                                         @PathVariable("qresponse_index") Long qresponse_index,
                                                                         @SessionAttribute("loginAdminIndex") Long adminIndex
    ) {

        boolean result = quotationService.removeQuotationResponse(qresponse_index);
        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        // (soft delete된 최신 DTO를 다시 조회해서 반환)
        QuotationResponseDTO deletedDTO = quotationService.getQuotationResponse(qresponse_index);
        return ResponseEntity.ok(deletedDTO);
    }

    // --- 견적 댓글 (Admin) ---
    // (Member 컨트롤러와 동일한 로직)

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

    @PostMapping("/comment/{qrequest_index}")
    public ResponseEntity<QuotationCommentDTO> registerQuotationComment(
            @PathVariable("qrequest_index") Long qrequest_index,
            @RequestBody QuotationCommentDTO quotationCommentDTO,
            @SessionAttribute("loginAdminIndex") Long adminIndex
    ) {

        quotationCommentDTO.setQrequest_index(qrequest_index);
        quotationCommentDTO.setAdmin_index(adminIndex);
        quotationCommentDTO.setWriter_type(EnumStatus.ADMIN);

        boolean result = quotationService.registerQuotationComment(quotationCommentDTO);

        if (!result) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(quotationCommentDTO);
    }

    @PutMapping("/comment/{qrequest_index}/{qcomment_index}")
    public ResponseEntity<QuotationCommentDTO> modifyQuotationComment(
            @PathVariable("qrequest_index") Long qrequest_index,
            @PathVariable("qcomment_index") Long qcomment_index,
            @RequestBody QuotationCommentDTO quotationCommentDTO,
            @SessionAttribute("loginAdminIndex") Long adminIndex
    ) {

        // 1. GET (검증)
        QuotationCommentDTO originalDTO = quotationService.getQuotationCommentById(qcomment_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getAdmin_index(), adminIndex)) {
            log.warn("Forbidden access attempt: Admin {} tried to delete qcomment {}", adminIndex, qrequest_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build(); // 403 Forbidden
        }

        quotationCommentDTO.setQcomment_index(qcomment_index);
        quotationCommentDTO.setAdmin_index(adminIndex); // 서비스단에서 검증용

        boolean result = quotationService.modifyQuotationComment(quotationCommentDTO);

        if (!result) {
            return ResponseEntity.notFound().build();
        }
        QuotationCommentDTO updatedDTO = quotationService.getQuotationCommentById(qcomment_index);
        return ResponseEntity.ok(updatedDTO);
    }

    @PutMapping("/comment/{qrequest_index}/{qcomment_index}:delete")
    public ResponseEntity<QuotationCommentDTO> removeQuotationComment(
            @PathVariable("qrequest_index") Long qrequest_index,
            @PathVariable("qcomment_index") Long qcomment_index,
            @SessionAttribute("loginAdminIndex") Long adminIndex
    ) {

        // 1. GET (검증)
        QuotationCommentDTO originalDTO = quotationService.getQuotationCommentById(qcomment_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getAdmin_index(), adminIndex)) {
            log.warn("Forbidden access attempt: Admin {} tried to delete qcomment {}", adminIndex, qcomment_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build(); // 403 Forbidden
        }

        // 3. CUD
        boolean result = quotationService.removeQuotationComment(qcomment_index);
        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        // (soft delete된 최신 DTO를 다시 조회해서 반환)
        QuotationCommentDTO deletedDTO = quotationService.getQuotationCommentById(qcomment_index);
        return ResponseEntity.ok(deletedDTO);
    }
}