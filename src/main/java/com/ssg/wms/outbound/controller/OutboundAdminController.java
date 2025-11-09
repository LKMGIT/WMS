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

@Log4j2
@RestController
@RequestMapping("/api/admin/outbound")
@RequiredArgsConstructor
public class OutboundAdminController {

    private final OutboundService outboundService;

    // === 출고요청 관리 (관리자) ===

    // 출고요청 목록 조회 (관리자) - GET
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

    // 출고요청 상세 조회 (관리자) - GET
    @GetMapping("/request/{or_index}")
    public ResponseEntity<OutboundRequestDetailDTO> getOutboundRequestDetail(
            @PathVariable("or_index") Long or_index,
            @ModelAttribute OutboundSearchDTO outboundSearchDTO, // (추가) 목록의 검색 조건
            @SessionAttribute("loginUserId") Long userId) {

        // (수정) Service 호출 시 searchDTO를 넘겨줌
        OutboundRequestDetailDTO requestDTO = outboundService.getOutboundRequestDetailById(outboundSearchDTO, or_index);

        if (requestDTO == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(requestDTO);
    }

    /**
     * 출고요청 반려 (관리자) - POST (BoardController.update 패턴 적용)
     */
    @PostMapping("/request/{or_index}/reject")
    public ResponseEntity<OutboundRequestDTO> rejectOutboundRequest(
            @PathVariable("or_index") Long or_index,
            @RequestBody OutboundResponseRegisterDTO responseRegisterDTO,
            @SessionAttribute("loginAdminId") Long adminId) {

        responseRegisterDTO.setOr_index(or_index);
        responseRegisterDTO.setAdmin_index(adminId);

        try {
            outboundService.rejectOutboundRequest(responseRegisterDTO);
            // 성공 시, 변경된 OutboundRequestDTO를 다시 조회하여 반환
            OutboundRequestDTO updatedDTO = outboundService.getOutboundRequestById(or_index);
            return ResponseEntity.ok(updatedDTO);
        } catch (Exception e) {
            log.error("Outbound reject failed: " + e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 출고요청 승인 (관리자) - POST (BoardController.update 패턴 적용)
     */
    @PostMapping("/request/{or_index}/approval")
    public ResponseEntity<OutboundRequestDTO> approveOutboundRequest(
            @PathVariable("or_index") Long or_index,
            @RequestBody OutboundResponseRegisterDTO responseRegisterDTO,
            @SessionAttribute("loginAdminId") Long adminId) {

        responseRegisterDTO.setOr_index(or_index);
        responseRegisterDTO.setAdmin_index(adminId);

        try {
            outboundService.approveOutboundRequest(responseRegisterDTO);
            // 성공 시, 변경된 OutboundRequestDTO를 다시 조회하여 반환
            OutboundRequestDTO updatedDTO = outboundService.getOutboundRequestById(or_index);
            return ResponseEntity.ok(updatedDTO);
        } catch (Exception e) {
            log.error("Outbound approve failed: " + e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    // === 출고지시서 관리 (관리자) ===

    /**
     * 출고지시서 목록 조회 (관리자) - GET
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

    // 출고지시서 상세 조회 (관리자) - GET
    @GetMapping("/instruction/{si_index}")
    public ResponseEntity<ShippingInstructionDetailDTO> getShippingInstructionDetail(
            @PathVariable("si_index") Long si_index,
            @ModelAttribute OutboundSearchDTO outboundSearchDTO,
            @SessionAttribute("loginAdminId") Long adminId) {

        ShippingInstructionDetailDTO detailDTO = outboundService.getShippingInstructionDetailById(outboundSearchDTO, si_index);
        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(detailDTO);
    }

    /**
     * 출고지시서 삭제 (관리자) - PUT (Soft Delete)
     * (삭제는 ReplyController.delete()의 boolean Map 반환)
     */
    @PutMapping("/instruction/{si_index}:delete")
    public ResponseEntity<ShippingInstructionDTO> removeShippingInstruction(
            @PathVariable("si_index") Long si_index,
            @SessionAttribute("loginAdminId") Long adminId) {

        boolean result = outboundService.removeShippingInstruction(si_index);

        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        ShippingInstructionDTO deletedDTO = outboundService.getShippingInstructionById(si_index);
        return ResponseEntity.ok(deletedDTO);
    }

    // === 배차 관리 (관리자) ===

    /**
     * 배차 가능 차량 목록 조회 (관리자) - GET
     * (이 API는 페이징이 아닌 List<DTO>를 직접 반환)
     */
    @GetMapping("/dispatch/available/{or_index}")
    public ResponseEntity<List<AvailableDispatchDTO>> getAvailableDispatch(
            @PathVariable("or_index") Long or_index,
            @SessionAttribute("loginAdminId") Long adminId) {

        List<AvailableDispatchDTO> list = outboundService.getAvailableDispatch(or_index);
        return ResponseEntity.ok(list);
    }

    /**
     * 배차 등록 (관리자) - POST
     * (Service가 boolean 반환, DTO를 반환하는 BoardController 패턴 적용)
     * (useGeneratedKeys가 DTO에 ID를 채워줘야 함)
     */
    @PostMapping("/dispatch")
    public ResponseEntity<DispatchDetailDTO> registerDispatch(
            @RequestBody DispatchDTO dispatchDTO,
            @SessionAttribute("loginAdminId") Long adminId) {

        boolean result = outboundService.registerDispatch(dispatchDTO);

        if (!result) {
            return ResponseEntity.badRequest().build();
        }
        DispatchDetailDTO createdDTO = outboundService.getDispatchById(dispatchDTO.getDispatch_index());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdDTO);
    }

    /**
     * 배차 상세 조회 (관리자) - GET
     */
    @GetMapping("/dispatch/{dispatch_index}")
    public ResponseEntity<DispatchDetailDTO> getDispatchDetail(
            @PathVariable("dispatch_index") Long dispatch_index,
            @SessionAttribute("loginAdminId") Long adminId) {

        DispatchDetailDTO detailDTO = outboundService.getDispatchById(dispatch_index);
        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(detailDTO);
    }

    /**
     * 배차 수정 (관리자) - PUT (BoardController.update 패턴)
     */
    @PutMapping("/dispatch/{dispatch_index}")
    public ResponseEntity<DispatchDetailDTO> modifyDispatch(
            @PathVariable("dispatch_index") Long dispatch_index,
            @RequestBody DispatchDTO dispatchDTO,
            @SessionAttribute("loginAdminId") Long adminId) {

        dispatchDTO.setDispatch_index(dispatch_index);
        boolean result = outboundService.modifyDispatch(dispatchDTO);

        if (!result) {
            return ResponseEntity.notFound().build();
        }

        DispatchDetailDTO updatedDTO = outboundService.getDispatchById(dispatch_index);
        return ResponseEntity.ok(updatedDTO);
    }

    /**
     * 배차 삭제(취소) (관리자) - PUT (Soft Delete)
     * (삭제는 ReplyController.delete()의 boolean Map 반환)
     */
    @PutMapping("/dispatch/{dispatch_index}:delete")
    public ResponseEntity<DispatchDetailDTO> removeDispatch(
            @PathVariable("dispatch_index") Long dispatch_index,
            @SessionAttribute("loginAdminId") Long adminId) {

        boolean result = outboundService.removeDispatch(dispatch_index);
        if (!result) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4. GET (BoardController 패턴)
        DispatchDetailDTO deletedDTO = outboundService.getDispatchById(dispatch_index);
        return ResponseEntity.ok(deletedDTO);
    }

    // === 운송장 관리 (관리자) ===

    /**
     * 운송장 등록 (관리자) - POST
     * (Service가 boolean 반환, DTO를 반환하는 BoardController 패턴 적용)
     */
    @PostMapping("/waybill")
    public ResponseEntity<WaybillDetailDTO> registerWaybill(
            @RequestBody WaybillDTO waybillDTO, // DTO로 받음
            @SessionAttribute("loginAdminId") Long adminId) {

        boolean result = outboundService.registerWaybill(waybillDTO.getSi_index());

        if (!result) {
            return ResponseEntity.badRequest().build();
        }

        // 등록 성공 시, DTO를 다시 조회해서 반환
        WaybillDetailDTO createdDTO = outboundService.getWaybillDetail(waybillDTO.getSi_index());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdDTO);
    }

    /**
     * 운송장 상세 조회 (관리자) - GET
     */
    @GetMapping("/waybill/{si_index}")
    public ResponseEntity<WaybillDetailDTO> getWaybillDetail(
            @PathVariable("si_index") Long si_index,
            @SessionAttribute("loginAdminId") Long adminId) {

        WaybillDetailDTO detailDTO = outboundService.getWaybillDetail(si_index);
        if (detailDTO == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(detailDTO);
    }
}