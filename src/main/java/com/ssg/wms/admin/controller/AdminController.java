package com.ssg.wms.admin.controller;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.user.domain.UserDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Log4j2
public class AdminController {

    private final AdminService adminService;

    /* =================== View: Users =================== */

    /**
     * 회원 목록 화면
     * - /admin/userList
     * - /admin/userList?status=APPROVED|PENDING|REJECTED
     */
    @GetMapping()
    public String dasboard(Model model) {
        return "admin/dashboard";
    }

    @GetMapping("/user_list")
    public String userList(@ModelAttribute("cri") Criteria criteria,
                           @RequestParam(value = "status", required = false) EnumStatus status,
                           @RequestParam(value = "company_code", required = false) Integer company_code,
                           Model model) {

        // Criteria에 검색값 싣기(필드 추가 권장, 아래 3) 참고)
        criteria.setCompany_code(company_code);
        criteria.setStatus(status);

        List<UserDTO> users = adminService.getList(criteria);
        PageDTO pageDTO = new PageDTO(criteria, adminService.getTotal(criteria));

        model.addAttribute("pageMaker", pageDTO);
        model.addAttribute("users", users);
        model.addAttribute("selectedStatus", status);  // (선택 유지용)
        model.addAttribute("selectedUserId", company_code);  // (선택 유지용)
        return "admin/user_list";
    }

    @GetMapping("/admin_list")
    public String adminList(@ModelAttribute("cri") Criteria criteria,
                            @RequestParam(value = "status", required = false) EnumStatus status,
                            @RequestParam(value = "role",   required = false) EnumStatus role,
                            @RequestParam(value = "type",   required = false) String type, // ★ 단일 선택
                            Model model) {

        criteria.setStatus(status);
        criteria.setRole(role);

        // 단일 선택 → 기존 구조(배열)로 매핑
        if (type != null && !type.isBlank()) {
            criteria.setTypes(new String[]{ type }); // typeStr = "T" / "I" / "P"
        } else {
            criteria.setTypes(null); // 전체로 처리
        }

        List<AdminDTO> admins = adminService.getAdminList(criteria);
        PageDTO pageDTO = new PageDTO(criteria, adminService.getAdminTotal(criteria));

        model.addAttribute("admins", admins);
        model.addAttribute("pageMaker", pageDTO);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedRole", role);
        model.addAttribute("selectedType", type); // 필요시 뷰에서 활용

        return "admin/admin_list";
    }

    /* =================== API: Users =================== */

    /** 회원 상태 변경 (APPROVED/PENDING/REJECTED) */
    @PostMapping("/api/users/{userId}/status")
    @ResponseBody
    public boolean updateUserStatusApi(@PathVariable String userId,
                                       @RequestParam EnumStatus status) {
        return adminService.updateUserStatus(userId, status);
    }

    /* =================== Admin 관리 (옵션) =================== */

    // 폼 화면
    @GetMapping("/register")
    public String showRegisterForm() {
        return "admin/register"; // /WEB-INF/views/admin/register.jsp
    }

    /** 관리자 등록 */
    @PostMapping("/api/register")
    @ResponseBody
    public Long registerAdmin(@RequestBody AdminDTO adminDTO) {
        return adminService.register(adminDTO);
    }

    @PostMapping("/register")
    public String submitRegister(@ModelAttribute AdminDTO adminDTO,
                                 RedirectAttributes rttr) {
        try {
            adminService.register(adminDTO);
            rttr.addFlashAttribute("registerOk", "계정이 생성되었습니다.");
            return "redirect:/login/loginForm";
        } catch (Exception e) {
            rttr.addFlashAttribute("registerError", "회원가입 실패");
            return "redirect:/admin/register";
        }
    }

    /** 관리자 단건 조회 */
    @GetMapping("/api/admins/{adminId}")
    @ResponseBody
    public AdminDTO getAdmin(@PathVariable String adminId) {
        Optional<AdminDTO> dto = adminService.getByAdminId(adminId);
        return dto.orElse(null);
    }

    // 수정 폼 진입 (세션 로그인 기준)
    @GetMapping("/admin/myinfo/edit")
    public String editMyInfo(HttpSession session, Model model){
        String adminId = (String) session.getAttribute("loginAdminId");
        if (adminId == null) return "redirect:/login/loginForm";

        Optional<AdminDTO> admin = adminService.getByAdminId(adminId);
        model.addAttribute("admin", admin);
        return "admin/myinfo_edit"; // 아래 JSP
    }

    //정보 확인 폼
    @GetMapping("/myinfo")
    public String myinfo(HttpSession session, Model model) {
        String adminId = (String) session.getAttribute("loginAdminId");
        if (adminId == null) {
            return "redirect:/login/loginForm";
        }

        Optional<AdminDTO> opt = adminService.getByAdminId(adminId);

        if (opt.isEmpty()) {
            model.addAttribute("errorMsg", "관리자 정보를 찾을 수 없습니다.");
            // 에러 페이지로 보내고 싶으면: return "admin/myinfo";
            // 또는: return "redirect:/login/loginForm";
            return "admin/myinfo";
        }

        model.addAttribute("admin", opt.get()); // <-- DTO 자체를 넣기
        return "admin/myinfo"; // /WEB-INF/views/admin/myinfo.jsp
    }

    /** 관리자 정보 수정 */
    @PatchMapping("/api/admins/{adminId}")
    @ResponseBody
    public boolean updateAdmin(@PathVariable String adminId,
                               @RequestBody AdminDTO adminDTO) {
        adminDTO.setAdminId(adminId);
        return adminService.update(adminDTO);
    }

    /** 관리자 상태 변경 (총관리자 APPROVED 등) */
    @PostMapping("/api/admins/{adminId}/status")
    @ResponseBody
    public boolean updateAdminStatus(@PathVariable String adminId,
                                     @RequestParam EnumStatus status) {
        return adminService.updateAdminStatus(adminId, status);
    }

    /** 관리자 역할 변경 (관리자/마스터) — EnumStatus에 MASTER 추가되어 있어야 함 */
    @PostMapping("/api/admins/{adminId}/role")
    @ResponseBody
    public boolean updateAdminRole(@PathVariable String adminId,
                                   @RequestParam EnumStatus role) {
        return adminService.updateAdminRole(adminId, role);
    }

    /** 비밀번호 재설정 화면 */
    @GetMapping("/forgot_password")
    public String forgotPasswordView(){
        log.info("HIT GET /admin/forgot_password"); // ← 반드시 찍히는지 확인
        return "admin/forgot_password";
    }

    /** 관리자 비밀번호 변경 */
    @PostMapping("/api/admins/{adminId}/password")
    @ResponseBody
    public boolean changePassword(@PathVariable String adminId,
                                  @RequestParam String newPassword) {
        return adminService.changePassword(adminId, newPassword);
    }

    /** 관리자 삭제 */
    @DeleteMapping("/api/admins/{adminId}")
    @ResponseBody
    public boolean deleteAdmin(@PathVariable String adminId) {
        return adminService.deleteByAdminId(adminId);
    }

    /** 아이디 찾기 폼 (이름+전화) */
    @GetMapping("/forgot_id")
    public String forgotIdForm() {
        return "admin/forgot_id"; // JSP 뷰
    }

    @PostMapping(
            value = "/api/forgot-id",
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.TEXT_PLAIN_VALUE
    )
    @ResponseBody
    public String forgotIdByPhone(@RequestBody AdminDTO dto) {
        log.info("[forgot-id] name={}, phone={}", dto.getAdminName(), dto.getAdminPhone());
        String id = adminService.findAdminId(dto.getAdminName(), dto.getAdminPhone());
        String masked = (id != null) ? maskId(id) : "";
        log.info("[forgot-id] result={}", masked);
        return masked;
    }

    private String maskId(String id) {
        if (id == null || id.length() <= 2) return "**";
        int front = Math.min(2, id.length());
        int back  = Math.min(2, id.length() - front);
        int hide  = Math.max(0, id.length() - (front + back));
        StringBuilder sb = new StringBuilder();
        sb.append(id, 0, front);
        for (int i = 0; i < hide; i++) sb.append('*');
        if (back > 0) sb.append(id.substring(id.length() - back));
        return sb.toString();
    }
}
