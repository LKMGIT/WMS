package com.ssg.wms.admin.controller;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.user.domain.UserDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;
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
    @GetMapping("/user_list")
    public String userList(@ModelAttribute("cri") Criteria criteria,
                           @RequestParam(value = "status", required = false) EnumStatus status,
                           @RequestParam(value = "userId", required = false) String userId,
                           Model model) {

        // Criteria에 검색값 싣기(필드 추가 권장, 아래 3) 참고)
        criteria.setUserId(userId);
        criteria.setStatus(status);

        List<UserDTO> users = adminService.getList(criteria);
        PageDTO pageDTO = new PageDTO(criteria, adminService.getTotal(criteria));

        model.addAttribute("pageMaker", pageDTO);
        model.addAttribute("users", users);
        model.addAttribute("selectedStatus", status);  // (선택 유지용)
        model.addAttribute("selectedUserId", userId);  // (선택 유지용)
        return "admin/user_list";
    }


    /* =================== API: Users =================== */

    /** 회원 상태 변경 (APPROVED/PENDING/REJECTED) */
    @PostMapping("/api/users/{userId}/status")
    @ResponseBody
    public boolean updateUserStatusApi(@PathVariable String userId,
                                       @RequestParam EnumStatus status) {
        return adminService.updateUserStatus(userId, status);
    }

    /* =================== View: Auth (옵션) =================== */

    /** 로그인 폼 */
    @GetMapping("/login")
    public String loginForm() {
        return "admin/login"; // 필요 시 생성
    }

    /** 로그인 처리 */
    @PostMapping("/login")
    public String doLogin(@RequestParam String adminId,
                          @RequestParam String adminPw,
                          HttpSession session,
                          RedirectAttributes rttr) {
        boolean ok = adminService.authenticate(adminId, adminPw);
        if (!ok) {
            rttr.addFlashAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "redirect:/admin/login";
        }
        session.setAttribute("loginAdminId", adminId);
        return "redirect:/admin/userList";
    }

    /** 로그아웃 */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin/login";
    }

    /* =================== Admin 관리 (옵션) =================== */

    /** 관리자 등록 */
    @PostMapping("/api/admins")
    @ResponseBody
    public Long registerAdmin(@RequestBody AdminDTO adminDTO) {
        return adminService.register(adminDTO);
    }

    /** 관리자 단건 조회 */
    @GetMapping("/api/admins/{adminId}")
    @ResponseBody
    public AdminDTO getAdmin(@PathVariable String adminId) {
        Optional<AdminDTO> dto = adminService.getByAdminId(adminId);
        return dto.orElse(null);
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
}
