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
    private long usersPrevMonth;     // 저번달 가입 수
    private long usersThisMonth;     // 이번달 가입 수

    // (기존 필드가 있어도 무방)
    private long usersYesterday;
    private long usersToday;
    private long usersDelta;
    private long inboundToday;
    private long outboundToday;

    // 일 단위 차트(7일/30일)
    private List<LocalDate> labels;
    private List<Long> usersDaily;
    private List<Long> inboundDaily;
    private List<Long> outboundDaily;
    
    private long inboundThisMonth;   // 이번달 입고 건수(또는 수량)
    private long outboundThisMonth;  // 이번달 출고 건수(또는 수량)

    // 월 단위 차트(최근 12개월)
    private List<String> monthLabels;     // "2024-12" 형식
    private List<Long> inboundMonthly;    // 월별 입고 카운트
    private List<Long> outboundMonthly;   // 월별 출고 카운트
}


