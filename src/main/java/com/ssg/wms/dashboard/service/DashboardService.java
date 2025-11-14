// src/main/java/com/ssg/wms/dashboard/service/DashboardService.java
package com.ssg.wms.dashboard.service;

import com.ssg.wms.dashboard.domain.DashBoardSummaryDTO;

public interface DashboardService {
    // range: "7d" | "30d" 등
    DashBoardSummaryDTO getSummary(String range);
}
