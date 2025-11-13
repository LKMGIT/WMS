// src/main/java/com/ssg/wms/dashboard/controller/DashboardController.java
package com.ssg.wms.dashboard.controller;

import com.ssg.wms.dashboard.domain.DashBoardSummaryDTO;
import com.ssg.wms.dashboard.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/dashboard")
    public String dashboard(
            @RequestParam(defaultValue = "30d") String range,  // "7d" | "30d"
            Model model
    ) {
        DashBoardSummaryDTO sum = dashboardService.getSummary(range);
        model.addAttribute("sum", sum);
        model.addAttribute("range", range);
        return "admin/dashboard";
    }
}
