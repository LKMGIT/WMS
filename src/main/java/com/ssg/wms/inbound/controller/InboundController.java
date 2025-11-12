package com.ssg.wms.inbound.controller;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
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
@RequestMapping("/api/inbound")
public class InboundController {

    @Autowired
    private InboundService inboundService;

    /** 입고 요청 등록 */
    @PostMapping("/request")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> requestInbound(
            @RequestBody InboundRequestDTO requestDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 사용자 ID 가져오기
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            Long inboundIndex = inboundService.requestInbound(requestDTO, userId);

            response.put("success", true);
            response.put("message", "입고 요청이 등록되었습니다.");
            response.put("inboundIndex", inboundIndex);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 요청 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 입고 요청 목록 조회 */
    @GetMapping("/request")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getInboundRequests(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<InboundRequestDTO> requests = inboundService.getRequests(keyword, status, userId);
        return ResponseEntity.ok(requests);
    }

    /** 입고 요청 상세 조회 */
    @GetMapping("/request/{inbound_index}")
    @ResponseBody
    public ResponseEntity<InboundRequestDTO> getInboundRequestDetail(
            @PathVariable("inbound_index") Long inboundIndex,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        InboundRequestDTO request = inboundService.getRequestWithDetails(inboundIndex);

        if (request == null) {
            return ResponseEntity.notFound().build();
        }

        // 본인의 요청인지 확인
        if (!request.getUserIndex().equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        return ResponseEntity.ok(request);
    }

    /** 입고 요청 수정 */
    @PutMapping("/request")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateInboundRequest(
            @RequestBody InboundRequestDTO requestDTO,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = inboundService.updateRequest(requestDTO);

            if (result) {
                response.put("success", true);
                response.put("message", "입고 요청이 수정되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "입고 요청 수정에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 요청 수정 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 입고 요청 취소 */
    @PutMapping("/request/{inbound_index}/cancel")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancelInboundRequest(
            @PathVariable("inbound_index") Long inboundIndex,
            @RequestParam String cancelReason,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = inboundService.cancelRequest(inboundIndex, cancelReason, userId);

            if (result) {
                response.put("success", true);
                response.put("message", "입고 요청이 취소되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "입고 요청 취소에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 요청 취소 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 입고 요청 삭제 */
    @DeleteMapping("/request/{inbound_index}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteInboundRequest(
            @PathVariable("inbound_index") Long inboundIndex,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = inboundService.deleteRequest(inboundIndex);

            if (result) {
                response.put("success", true);
                response.put("message", "입고 요청이 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "입고 요청 삭제에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 요청 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 기간별 입고 현황 조회 */
    @GetMapping("/status/period")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getInboundStatusByPeriod(
            @RequestParam String startDate,
            @RequestParam String endDate,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<InboundRequestDTO> statusList = inboundService.getInboundStatusByPeriod(startDate, endDate, userId);
        return ResponseEntity.ok(statusList);
    }

    /** 월별 입고 현황 조회 */
    @GetMapping("/status/month")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getInboundStatusByMonth(
            @RequestParam int year,
            @RequestParam int month,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<InboundRequestDTO> statusList = inboundService.getInboundStatusByMonth(year, month);
        return ResponseEntity.ok(statusList);
    }

    // 관리자 입고 관리 API
    /** 관리자용 입고 요청 목록 조회 */
    @GetMapping("/admin/inbound/request")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getAdminInboundRequests(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            HttpSession session) {

        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<InboundRequestDTO> requests = inboundService.getAdminInboundRequests(keyword, status);
        return ResponseEntity.ok(requests);
    }

    /** 입고 요청 승인 (관리자) */
    @PutMapping("/admin/inbound/request/{inbound_index}/approve")
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

    /** 입고 상세 위치 지정 (관리자) */
    @PutMapping("/admin/inbound/detail/{detail_index}/location")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateInboundLocation(
            @PathVariable("detail_index") Integer detailIndex,
            @RequestParam String location,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = inboundService.updateLocation(detailIndex, location, adminId);

            if (result) {
                response.put("success", true);
                response.put("message", "입고 위치가 지정되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "입고 위치 지정에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 위치 지정 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** QR 코드 생성 (관리자) */
    @PostMapping("/admin/inbound/detail/{detail_index}/qrcode")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateQrCode(
            @PathVariable("detail_index") Integer detailIndex,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            String qrCode = inboundService.generateQrCode(detailIndex, adminId);

            response.put("success", true);
            response.put("message", "QR 코드가 생성되었습니다.");
            response.put("qrCode", qrCode);
            // 구글 QR API URL 생성
            response.put("qrCodeImageUrl", "https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=" + qrCode);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "QR 코드 생성 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** QR 코드로 입고 상세 조회 */
    @GetMapping("/detail/qr")
    @ResponseBody
    public ResponseEntity<InboundDetailDTO> getInboundDetailByQr(
            @RequestParam String qrCode) {

        InboundDetailDTO detail = inboundService.getDetailByQr(qrCode);

        if (detail == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(detail);
    }

    /** 입고 완료 처리 (관리자) */
    @PutMapping("/admin/inbound/detail/{detail_index}/complete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> completeInbound(
            @PathVariable("detail_index") Integer detailIndex,
            @RequestParam Integer receivedQuantity,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Long adminId = (Long) session.getAttribute("adminId");
            if (adminId == null) {
                response.put("success", false);
                response.put("message", "관리자 권한이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            boolean result = inboundService.completeInbound(detailIndex, receivedQuantity, adminId);

            if (result) {
                response.put("success", true);
                response.put("message", "입고가 완료되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "입고 완료 처리에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "입고 완료 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /** 관리자용 기간별 입고 현황 조회 */
    @GetMapping("/admin/inbound/status/period")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getAdminInboundStatusByPeriod(
            @RequestParam String startDate,
            @RequestParam String endDate,
            HttpSession session) {

        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // userId를 null로 전달하여 전체 조회
        List<InboundRequestDTO> statusList = inboundService.getInboundStatusByPeriod(startDate, endDate, null);
        return ResponseEntity.ok(statusList);
    }

    /** 관리자용 월별 입고 현황 조회 */
    @GetMapping("/admin/inbound/status/month")
    @ResponseBody
    public ResponseEntity<List<InboundRequestDTO>> getAdminInboundStatusByMonth(
            @RequestParam int year,
            @RequestParam int month,
            HttpSession session) {

        Long adminId = (Long) session.getAttribute("adminId");
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // 관리자는 전체 현황 조회
        List<InboundRequestDTO> statusList = inboundService.getInboundStatusByMonth(year, month);
        return ResponseEntity.ok(statusList);
    }

    // JSP 뷰 반환 메서드 (화면 이동)
    /** 입고 요청 등록 화면 */
    @GetMapping("/register")
    public String showInboundRegisterForm() {
        return "inbound/register";
    }

    /** 입고 요청 목록 화면 */
    @GetMapping("/list")
    public String showInboundList() {
        return "inbound/list";
    }

    /** 입고 요청 상세 화면 */
    @GetMapping("/detail/{inbound_index}")
    public String showInboundDetail(@PathVariable("inbound_index") Long inboundIndex, Model model) {
        model.addAttribute("inboundIndex", inboundIndex);
        return "inbound/detail";
    }

    /** QR 조회 화면 */
    @GetMapping("/qr")
    public String showQrSearch() {
        return "inbound/qr";
    }

    /** 관리자 입고 관리 화면 */
    @GetMapping("/admin/inbound")
    public String showAdminInbound() {
        return "admin/inbound/list";
    }
}
