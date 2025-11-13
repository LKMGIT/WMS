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

/**
 * 입고(Inbound) 기능의 JSON 데이터(API)를 담당하는 REST 컨트롤러
 * - 뷰 컨트롤러(@Controller)와 경로가 겹치지 않도록 API 엔드포인트를 설계합니다.
 * - 모든 메서드는 DTO, Map 등을 JSON으로 반환합니다.
 */
@RestController
@RequestMapping("/inbound/admin") // 공통 경로
@RequiredArgsConstructor
public class InboundController {

    private final InboundService inboundService;

    // --- 1. 입고 목록 (List) API ---
    /**
     * [API] 입고 요청 목록 조회 (페이징 + 검색)
     * (list.jsp의 JavaScript가 호출)
     *
     * @GetMapping("/requests") -> /inbound/admin/requests
     */
    @GetMapping("/requests")
    public ResponseEntity<Map<String, Object>> getInboundRequestList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchKeyword,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            // 🔥 추가: 창고와 상태 필터 파라미터
            @RequestParam(required = false) Integer warehouseIndex,
            @RequestParam(required = false) String approvalStatus) {

        Map<String, Object> response = new HashMap<>();
        try {
            // 1. Service용 파라미터 맵 생성
            Map<String, Object> params = new HashMap<>();
            params.put("skip", (page - 1) * size);
            params.put("size", size);

            // 기존 검색 조건
            if (searchType != null && searchKeyword != null) {
                params.put("searchType", searchType);
                params.put("searchKeyword", searchKeyword);
            }

            // 날짜 범위 검색
            if (fromDate != null && toDate != null) {
                params.put("fromDate", fromDate);
                params.put("toDate", toDate);
            }

            // 🔥 추가: 창고 필터
            if (warehouseIndex != null) {
                params.put("warehouseIndex", warehouseIndex);
            }

            // 🔥 추가: 상태 필터
            if (approvalStatus != null && !approvalStatus.isEmpty()) {
                params.put("approvalStatus", approvalStatus);
            }

            // 2. 데이터 조회
            List<InboundRequestDTO> list = inboundService.getRequestList(params);

            Map<String, Object> searchParams = (Map) ((HashMap) params).clone();
            searchParams.remove("skip");
            searchParams.remove("size");
            int total = inboundService.getRequestCount(searchParams);

            // 3. 페이징 계산 (서버에서 해주는 것이 편리)
            int pageSize = 10;
            int totalPage = (int) Math.ceil((double) total / size);
            int endPage = (int) (Math.ceil(page / (double) pageSize)) * pageSize;
            int startPage = endPage - (pageSize - 1);
            endPage = Math.min(endPage, totalPage);

            // 4. 응답 데이터 구성
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

    // --- 2. 입고 상세 (Detail) API ---
    /**
     * [API] 입고 요청 상세 조회
     * (detail.jsp의 loadInboundDetail 함수가 호출)
     *
     * @GetMapping("/request/{inboundIndex}") -> /inbound/admin/request/1
     */
    @GetMapping("/request/{inboundIndex}")
    public ResponseEntity<InboundRequestDTO> getInboundRequestDetail(
            @PathVariable("inboundIndex") Long inboundIndex) {
        try {
            InboundRequestDTO dto = inboundService.getRequestById(inboundIndex);
            if (dto == null) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND); // 404
            }
            return new ResponseEntity<>(dto, HttpStatus.OK); // 200 + JSON
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    /**
     * [API] 입고 요청 승인
     * (detail.jsp의 approveRequest 함수가 호출)
     *
     * @PutMapping("/request/{inboundIndex}/approve")
     */
    @PutMapping("/request/{inboundIndex}/approve")
    public ResponseEntity<Map<String, Object>> approveInboundRequest(
            @PathVariable("inboundIndex") Long inboundIndex) {

        Map<String, Object> response = new HashMap<>();
        try {
            inboundService.approveRequest(inboundIndex);
            response.put("success", true);
            response.put("message", "요청이 성공적으로 승인되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "승인 처리 중 오류가 발생했습니다: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    /**
     * 🔥 [NEW API] 입고 요청 취소
     * (detail.jsp의 cancelRequest 함수가 호출)
     *
     * @PutMapping("/request/{inboundIndex}/cancel")
     */
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

    /**
     * [API] 입고 상세 내역 처리 (위치 지정/수량 확정)
     * (detail.jsp의 '위치' 버튼 클릭 시 호출할 API 예시)
     *
     * @PutMapping("/detail/process")
     */
    @PutMapping("/detail/process")
    public ResponseEntity<Map<String, Object>> processInboundDetail(
            @RequestBody InboundDetailDTO detailDTO) { // (중요) JS에서 JSON으로 데이터를 보내야 함

        Map<String, Object> response = new HashMap<>();
        try {
            // (재고 로직이 없는) 입고 처리 서비스 호출
            inboundService.processInboundDetail(detailDTO);
            response.put("success", true);
            response.put("message", "입고 상세 내역이 처리되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 처리 중 오류: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // --- 3. 입고 통계 (Stats) API ---
    /**
     * [API] 입고 통계 조회
     * (stats.jsp의 JavaScript가 호출)
     *
     * @GetMapping("/stats/data") -> /inbound/admin/stats/data
     */
    @GetMapping("/stats/data") // (주의) /stats가 아닌 /stats/data
    public ResponseEntity<Map<String, Object>> getInboundStats(
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {

        Map<String, Object> response = new HashMap<>();
        try {
            LocalDate now = LocalDate.now();

            // 1. 기간별 현황
            if (fromDate == null || toDate == null) {
                fromDate = now.minusDays(7).toString();
                toDate = now.toString();
            }
            Map<String, Object> periodParams = new HashMap<>();
            periodParams.put("fromDate", fromDate);
            periodParams.put("toDate", toDate);
            List<InboundRequestDTO> periodList = inboundService.getStatsByPeriod(periodParams);

            // 2. 월별 현황
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