package com.ssg.wms.dashboard.domain;


import lombok.Data;

import java.time.LocalDate;
import java.util.List;

// com.ssg.wms.dashboard.domain.DashBoardSummaryDTO
// com.ssg.wms.dashboard.domain.DashBoardSummaryDTO
@Data
public class DashBoardSummaryDTO {
    // KPI
    private long usersTotal;
    private long usersPrevMonth;   // 저번달 가입 수
    private long usersThisMonth;   // 이번달 가입 수

    // 선택(원하면 유지)
    private long usersYesterday;
    private long usersToday;
    private long usersDelta;
    private long inboundToday;
    private long outboundToday;

    // Charts
    private List<LocalDate> labels;
    private List<Long> usersDaily;
    private List<Long> inboundDaily;
    private List<Long> outboundDaily;
}


