package com.ssg.wms.inbound.controller;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import com.ssg.wms.inbound.service.InboundService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/inbound/admin")
@RequiredArgsConstructor
public class InboundController {

    private final InboundService inboundService;

    // --- 1. 입고 목록 (List) API ---
    @GetMapping("/requests")
    public ResponseEntity<Map<String, Object>> getInboundRequestList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchKeyword,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) Long warehouseIndex,
            @RequestParam(required = false) String approvalStatus) {

        Map<String, Object> response = new HashMap<>();
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("skip", (page - 1) * size);
            params.put("size", size);

            if (searchType != null && searchKeyword != null) {
                params.put("searchType", searchType);
                params.put("searchKeyword", searchKeyword);
            }
            if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                params.put("fromDate", fromDate);
                params.put("toDate", toDate);
            }
            if (warehouseIndex != null) {
                params.put("warehouseIndex", warehouseIndex);
            }
            if (approvalStatus != null && !approvalStatus.isEmpty()) {
                params.put("approvalStatus", approvalStatus);
            }

            List<InboundRequestDTO> list = inboundService.getRequestList(params);

            Map<String, Object> searchParams = (Map) ((HashMap) params).clone();
            searchParams.remove("skip");
            searchParams.remove("size");
            int total = inboundService.getRequestCount(searchParams);

            int pageSize = 10;
            int totalPage = (int) Math.ceil((double) total / size);
            int endPage = (int) (Math.ceil(page / (double) pageSize)) * pageSize;
            int startPage = endPage - (pageSize - 1);
            endPage = Math.min(endPage, totalPage);

            response.put("list", list);
            response.put("total", total);
            response.put("page", page);
            response.put("startPage", startPage);
            response.put("endPage", endPage);
            response.put("prev", startPage > 1);
            response.put("next", totalPage > endPage);

            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            response.put("message", "목록 조회 중 오류 발생: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // --- 2. 입고 상세 ---
    @GetMapping("/request/{inboundIndex}")
    public ResponseEntity<InboundRequestDTO> getInboundRequestDetail(
            @PathVariable("inboundIndex") Long inboundIndex) {
        try {
            InboundRequestDTO dto = inboundService.getRequestById(inboundIndex);
            if (dto == null) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
            return new ResponseEntity<>(dto, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 🔥 [수정] 입고 요청 승인 (구역 선택 후 승인)
     */
    @PutMapping("/request/{inboundIndex}/approve")
    public ResponseEntity<Map<String, Object>> approveInboundRequest(
            @PathVariable("inboundIndex") Long inboundIndex,
            @RequestBody InboundRequestDTO requestDTO) {

        Map<String, Object> response = new HashMap<>();
        try {
            // 1. 구역 번호 유효성 검사 (DTO의 cancelReason 필드에 임시로 구역 코드를 받음)
            if (requestDTO.getCancelReason() == null || requestDTO.getCancelReason().isEmpty()) {
                response.put("success", false);
                response.put("message", "승인할 구역을 반드시 선택해야 합니다.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            // 2. 기존 요청 정보를 가져옴
            InboundRequestDTO existingRequest = inboundService.getRequestById(inboundIndex);
            if (existingRequest == null) {
                response.put("success", false);
                response.put("message", "요청 번호 " + inboundIndex + "를 찾을 수 없습니다.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            // 3. 기존 DTO에 구역 번호를 설정 (cancelReason에 임시로 담아 서비스로 전달)
            existingRequest.setInboundIndex(inboundIndex);
            existingRequest.setCancelReason(requestDTO.getCancelReason());

            inboundService.approveRequest(existingRequest);

            response.put("success", true);
            response.put("message", "요청이 성공적으로 승인 및 구역 배정되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "승인 처리 중 오류가 발생했습니다: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/request/{inboundIndex}/cancel")
    public ResponseEntity<Map<String, Object>> cancelInboundRequest(
            @PathVariable("inboundIndex") Long inboundIndex,
            @RequestBody Map<String, String> payload) {

        Map<String, Object> response = new HashMap<>();
        try {
            String cancelReason = payload.get("cancelReason");
            if (cancelReason == null || cancelReason.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "취소 사유를 입력해주세요.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }
            InboundRequestDTO dto = new InboundRequestDTO();
            dto.setInboundIndex(inboundIndex);
            dto.setCancelReason(cancelReason);
            inboundService.cancelRequest(dto);
            response.put("success", true);
            response.put("message", "요청이 성공적으로 취소되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "취소 처리 중 오류가 발생했습니다: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /** '승인' 이후, 상세 내역을 '수정'할 때 사용됩니다. */
    @PutMapping("/detail/process")
    public ResponseEntity<Map<String, Object>> processInboundDetail(
            @RequestBody InboundDetailDTO detailDTO) {

        Map<String, Object> response = new HashMap<>();
        try {
            inboundService.processInboundDetail(detailDTO); // 'UPDATE' 로직 호출
            response.put("success", true);
            response.put("message", "입고 상세 내역이 수정되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 처리(수정) 중 오류: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // --- 3. 입고 통계 (Stats) API ---
    @GetMapping("/stats/data")
    public ResponseEntity<Map<String, Object>> getInboundStats(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {

        Map<String, Object> response = new HashMap<>();
        try {
            LocalDate now = LocalDate.now();
            if (fromDate == null || fromDate.isEmpty() || toDate == null || toDate.isEmpty()) {
                fromDate = now.minusDays(7).toString();
                toDate = now.toString();
            }
            Map<String, Object> periodParams = new HashMap<>();
            periodParams.put("fromDate", fromDate);
            periodParams.put("toDate", toDate);
            List<InboundRequestDTO> periodList = inboundService.getStatsByPeriod(periodParams);

            if (year == null || month == null) {
                year = now.getYear();
                month = now.getMonthValue();
            }
            List<InboundRequestDTO> monthList = inboundService.getStatsByMonth(year, month);

            response.put("periodList", periodList);
            response.put("monthList", monthList);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("message", "통계 조회 중 오류 발생: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}