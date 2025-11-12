package com.ssg.wms.dashboard.domain;


import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class DashBoardSummaryDTO {
    // KPI
    private long usersTotal;
    private long usersYesterday;   // 어제 가입 수
    private long usersToday;       // 오늘 가입 수
    private long usersDelta;       // 오늘-어제
    private long inboundToday;     // 오늘 입고 건수
    private long outboundToday;    // 오늘 출고 건수

    // Charts (최근 7일)
    private List<LocalDate> labels;
    private List<Long> usersDaily;     // 날짜별 가입 수
    private List<Long> inboundDaily;   // 날짜별 입고 건수
    private List<Long> outboundDaily;  // 날짜별 출고 건수
}
