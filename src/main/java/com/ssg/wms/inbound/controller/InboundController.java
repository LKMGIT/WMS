package com.ssg.wms.inbound.controller;

import com.ssg.wms.inbound.domain.InboundRequestDTO;
import com.ssg.wms.inbound.service.InboundService;
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
@RequestMapping("/inbound")
public class InboundController {

    @Autowired
    private InboundService inboundService;

    /**
     * 입고 요청 목록 조회
     */
    @GetMapping("/admin/request")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getAdminInboundRequests(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            HttpSession session) {
        // ... (기존 로직 유지)
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        List<InboundRequestDTO> requests = inboundService.getAdminInboundRequests(keyword, status);
        return ResponseEntity.ok(requests);
    }

    /**
     * 입고 요청 상세 조회
     */
    @GetMapping("/admin/request/{inbound_index}")
    @ResponseBody
    public ResponseEntity<InboundRequestDTO> getAdminInboundRequestDetail(
            @PathVariable("inbound_index") Long inboundIndex,
            HttpSession session) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        // 관리자는 권한 체크 없이 상세 조회
        InboundRequestDTO request = inboundService.getRequestWithDetails(inboundIndex);
        return request == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(request);
    }

    /**
     * 입고 요청 승인
     */
    @PutMapping("/admin/request/{inbound_index}/approve")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> approveInboundRequest(
            @PathVariable("inbound_index") Long inboundIndex,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            boolean result = inboundService.approveRequest(inboundIndex, adminId);
            if (result) {
                response.put("success", true);
                response.put("message", "입고 요청이 승인되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "입고 요청 승인에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 요청 승인 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 기간별 입고 현황 조회
     */
    @GetMapping("/admin/status/period")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getAdminInboundStatusByPeriod(
            @RequestParam String startDate,
            @RequestParam String endDate,
            HttpSession session) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        List<InboundRequestDTO> statusList = inboundService.getInboundStatusByPeriod(startDate, endDate, null);
        return ResponseEntity.ok(statusList);
    }

    /**
     *  월별 입고 현황 조회
     */
    @GetMapping("/admin/status/month")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getAdminInboundStatusByMonth(
            @RequestParam int year,
            @RequestParam int month,
            HttpSession session) {
        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        List<InboundRequestDTO> statusList = inboundService.getInboundStatusByMonth(year, month);
        return ResponseEntity.ok(statusList);
    }


    /**
     * 입고 요청 상세 화면 (Admin)
     */
    @GetMapping("/admin/detail/{inbound_index}") // URL을 관리자용으로 명확히 변경
    public String showAdminInboundDetail(@PathVariable("inbound_index") Long inboundIndex, Model model) {
        model.addAttribute("inboundIndex", inboundIndex);
        return "inbound/admin/detail"; // View 경로도 관리자용으로 변경
    }

    /**
     * QR 조회 화면 (Admin)
     */
    @GetMapping("/admin/qr")
    public String showAdminQrSearch() {
        return "inbound/admin/qr"; // View 경로도 관리자용으로 변경
    }

    /**
     * 입고 요청 목록 화면 (Admin)
     */
    @GetMapping("/admin/list")
    public String showAdminInboundList() {
        return "inbound/admin/list";
    }

    /**
     * 관리자 입고 목록 조회 (폼)
     */
    @GetMapping("/admin/form")
    public String showAdminInboundForm() {
        return "inbound/admin/form";
    }

    /**
     * 관리자용 기간별 입고 현황 조회 화면
     */
    @GetMapping("/admin/period")
    public String showAdminInboundPeriodStatus() {
        return "inbound/admin/period";
    }

    /**
     * 관리자용 월별 입고 현황 조회 화면
     */
    @GetMapping("/admin/month")
    public String showAdminInboundMonthStatus() {
        return "inbound/admin/month";
    }
}