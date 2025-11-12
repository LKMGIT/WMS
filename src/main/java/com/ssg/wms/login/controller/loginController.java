package com.ssg.wms.login.controller;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.login.LoginResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/login")
@Log4j2
@RequiredArgsConstructor
public class loginController {

    private final AdminService adminService;

    /** 로그인 폼 */
    @GetMapping("/loginForm")
    public void loginForm() {
    }

    /** 로그인 처리 */
    @PostMapping("/loginForm")
    public String doLogin(@RequestParam String adminId,
                          @RequestParam String adminPw,
                          HttpSession session,
                          RedirectAttributes rttr) {
        LoginResult res = adminService.authenticate(adminId, adminPw);
        switch (res) {

            case SUCCESS:
                // 필요한 세션 정보 세팅
                AdminDTO admin = adminService.getByAdminId(adminId).get();
                session.setAttribute("loginAdmin", admin);

                //내가 임의로 추가
                session.setAttribute("loginAdminIndex", admin.getAdminIndex());

                session.setAttribute("loginAdminId", admin.getAdminId());
                session.setAttribute("loginAdminName", admin.getAdminName());
                session.setAttribute("loginAdminStatus", admin.getAdminStatus());
                session.setAttribute("loginAdminRole", admin.getAdminRole());

                return "redirect:/admin/user_list";

            case NOT_FOUND:
                rttr.addFlashAttribute("loginError", "존재하지 않는 아이디입니다.");
                break;

            case NOT_APPROVED:
                rttr.addFlashAttribute("loginError", "승인되지 않은 계정입니다.");
                break;

            case BAD_CREDENTIALS:
                rttr.addFlashAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
                break;

        }
        return "redirect:/login/loginForm";
    }

    /** 로그아웃 */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login/loginForm";
    }
}
