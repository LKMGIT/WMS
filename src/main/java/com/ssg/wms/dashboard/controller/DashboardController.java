package com.ssg.wms.dashboard.controller;

import com.ssg.wms.dashboard.domain.DashBoardSummaryDTO;
import com.ssg.wms.dashboard.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin") // 공통 prefix는 /admin
public class DashboardController {

    private final DashboardService dashboardService;

//    /** 대시보드 요약 API (JSON) */
//    @GetMapping("/api/dashboard/summary")
//    @ResponseBody
//    public DashBoardSummaryDTO summary() {
//        return dashboardService.getSummaryLast7Days();
//    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        DashBoardSummaryDTO sum = dashboardService.getSummaryLast7Days();
        model.addAttribute("sum", sum);
        return "admin/dashboard"; // /WEB-INF/views/admin/dashboard.jsp
    }
}
