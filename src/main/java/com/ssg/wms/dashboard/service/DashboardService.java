package com.ssg.wms.dashboard.service;

import com.ssg.wms.dashboard.domain.DashBoardSummaryDTO;

public interface DashboardService {
    DashBoardSummaryDTO getSummaryLast7Days();
}
