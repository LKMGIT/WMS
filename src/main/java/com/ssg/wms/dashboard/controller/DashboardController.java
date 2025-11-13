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

    // com.ssg.wms.dashboard.controller.DashboardController
    @GetMapping("/dashboard")
    public String dashboard(
            @RequestParam(defaultValue = "30d") String range,  // "7d" | "30d"
            Model model
    ) {
        DashBoardSummaryDTO sum = dashboardService.getSummary(range);
        model.addAttribute("sum", sum);
        model.addAttribute("range", range); // JSP에서 선택 상태 유지 등에 사용 가능
        return "admin/dashboard"; // /WEB-INF/views/admin/dashboard.jsp
    }

}
