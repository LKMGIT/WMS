package com.ssg.wms.outbound.controller;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.outbound.domain.*;
import com.ssg.wms.outbound.service.OutboundService;
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
@RequestMapping("/api/outbound")
@RequiredArgsConstructor
public class OutboundMemberController {

    private final OutboundService outboundService;

    /**
     * 출고요청 목록 조회 (회원) - GET
     */
    @GetMapping("/request")
    public Map<String, Object> getOutboundRequests(
            @ModelAttribute Criteria criteria,
            @ModelAttribute OutboundSearchDTO outboundSearchDTO) {

        List<OutboundRequestDTO> list = outboundService.getOutboundRequestList(criteria, outboundSearchDTO);
        int total = outboundService.getOutboundRequestTotalCount(outboundSearchDTO);

        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("pageDTO", pageDTO);

        return map;
    }

    /**
     * 출고요청 등록 (회원) - POST
     * (MyBatis의 useGeneratedKeys=true가 DTO에 ID를 채워줘야 함)
     */
    @PostMapping("/request")
    public ResponseEntity<OutboundRequestDTO> registerOutboundRequest(
            @RequestBody OutboundRequestDTO outboundRequestDTO,
            @SessionAttribute("loginUserId") Long userId) {

        outboundRequestDTO.setUser_index(userId);
        boolean result = outboundService.registerOutboundRequest(outboundRequestDTO);

        if (!result) {
            return ResponseEntity.badRequest().build();
        }

        // (useGeneratedKeys로 or_index가 채워졌다고 가정)
        OutboundRequestDTO createdDTO = outboundService.getOutboundRequestById(outboundRequestDTO.getOr_index());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdDTO);
    }

    /**
     * 출고요청 상세 조회 (회원) - GET
     */
    @GetMapping("/request/{or_index}")
    public ResponseEntity<OutboundRequestDetailDTO> getOutboundRequestDetail(
            @PathVariable("or_index") Long or_index,
            @ModelAttribute OutboundSearchDTO outboundSearchDTO,
            @SessionAttribute("loginUserId") Long userId) {

        OutboundRequestDetailDTO requestDTO = outboundService.getOutboundRequestDetailById(outboundSearchDTO, or_index);

        if (requestDTO == null) {
            return ResponseEntity.notFound().build();
        }

        if (!Objects.equals(requestDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to access outbound request {}", userId, or_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        return ResponseEntity.ok(requestDTO);
    }

    /**
     * 출고요청 수정 (회원) - PUT (BoardController.update 패턴)
     */
    @PutMapping("/request/{or_index}")
    public ResponseEntity<OutboundRequestDTO> modifyOutboundRequest(
            @PathVariable("or_index") Long or_index,
            @RequestBody OutboundRequestDTO outboundRequestDTO,
            @SessionAttribute("loginUserId") Long userId) {

        // 1. GET (검증)
        OutboundRequestDTO originalDTO = outboundService.getOutboundRequestById(or_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to modify outbound request {}", userId, or_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        // ▲▲▲ 검증 끝 ▲▲▲

        // 3. CUD
        outboundRequestDTO.setOr_index(or_index);
        outboundRequestDTO.setUser_index(userId);
        boolean result = outboundService.modifyOutboundRequest(outboundRequestDTO);

        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        OutboundRequestDTO updatedDTO = outboundService.getOutboundRequestById(or_index);
        return ResponseEntity.ok(updatedDTO);
    }

    /**
     * 출고요청 삭제 (회원) - PUT (Soft Delete) (BoardController.delete 패턴)
     */
    @PutMapping("/request/{or_index}:delete")
    public ResponseEntity<OutboundRequestDTO> removeOutboundRequest(
            @PathVariable("or_index") Long or_index,
            @SessionAttribute("loginUserId") Long userId) {

        // 1. GET (검증)
        OutboundRequestDTO originalDTO = outboundService.getOutboundRequestById(or_index);
        if (originalDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // 2. ▼▼▼ 본인 글 검증 ▼▼▼
        if (!Objects.equals(originalDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to delete outbound request {}", userId, or_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        // ▲▲▲ 검증 끝 ▲▲▲

        // 3. CUD
        boolean result = outboundService.removeOutboundRequest(or_index);

        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        OutboundRequestDTO deletedDTO = outboundService.getOutboundRequestById(or_index);
        return ResponseEntity.ok(deletedDTO);
    }

    /**
     * 출고지시서 목록 조회 (회원) - GET
     */
    @GetMapping("/instruction")
    public Map<String, Object> getShippingInstructions(
            @ModelAttribute Criteria criteria,
            @ModelAttribute OutboundSearchDTO outboundSearchDTO) {

        List<ShippingInstructionDTO> list = outboundService.getShippingInstructionList(criteria, outboundSearchDTO);
        int total = outboundService.getShippingInstructionTotalCount(outboundSearchDTO);

        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("pageDTO", pageDTO);

        return map;
    }

    /**
     * 출고지시서 상세 조회 (회원) - GET
     */
    @GetMapping("/instruction/{si_index}")
    public ResponseEntity<ShippingInstructionDetailDTO> getShippingInstructionDetail(
            @PathVariable("si_index") Long si_index,
            @ModelAttribute OutboundSearchDTO outboundSearchDTO,
            @SessionAttribute("loginUserId") Long userId) {

        ShippingInstructionDetailDTO detailDTO = outboundService.getShippingInstructionDetailById(outboundSearchDTO, si_index);
        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }

        if (!Objects.equals(detailDTO.getUser_index(), userId)) {
            log.warn("Forbidden access attempt: User {} tried to access SI {}", userId, si_index);
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.ok(detailDTO);
    }

    /**
     * 배차 상세 조회 (회원) - GET
     */
    @GetMapping("/dispatch/{dispatch_index}")
    public ResponseEntity<DispatchDetailDTO> getDispatchDetail(
            @PathVariable("dispatch_index") Long dispatch_index,
            @SessionAttribute("loginUserId") Long userId) {

        DispatchDetailDTO detailDTO = outboundService.getDispatchById(dispatch_index);
        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(detailDTO);
    }

    /**
     * 운송장 상세 조회 (회원) - GET
     */
    @GetMapping("/waybill/{si_index}")
    public ResponseEntity<WaybillDetailDTO> getWaybillDetail(
            @PathVariable("si_index") Long si_index,
            @SessionAttribute("loginUserId") Long userId) {

        WaybillDetailDTO detailDTO = outboundService.getWaybillDetail(si_index);
        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(detailDTO);
    }
}