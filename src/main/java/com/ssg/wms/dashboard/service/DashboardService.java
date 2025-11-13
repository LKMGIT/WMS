package com.ssg.wms.dashboard.service;

import com.ssg.wms.dashboard.domain.DashBoardSummaryDTO;

// com.ssg.wms.dashboard.service.DashboardService
public interface DashboardService {
    DashBoardSummaryDTO getSummary(String range); // "7d" 또는 "30d"
}

