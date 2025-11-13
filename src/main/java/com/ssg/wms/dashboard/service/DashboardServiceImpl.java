// com.ssg.wms.dashboard.service.DashboardServiceImpl
package com.ssg.wms.dashboard.service;

import com.ssg.wms.dashboard.domain.DashBoardSummaryDTO;
import com.ssg.wms.dashboard.mappers.DashboardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;

// com.ssg.wms.dashboard.service.DashboardServiceImpl
// com.ssg.wms.dashboard.service.DashboardServiceImpl
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardServiceImpl implements DashboardService {

    private final DashboardMapper mapper;

    @Override
    public DashBoardSummaryDTO getSummary(String range) {
        // 7d / 30d 범위
        int days = ("30d".equalsIgnoreCase(range)) ? 30 : 7;

        LocalDate today = LocalDate.now();
        LocalDate start = today.minusDays(days - 1); // 예: 30d면 오늘-29일부터

        // 일간 KPI (기존)
        String sToday     = today.toString();
        String sYesterday = today.minusDays(1).toString();

        long usersTotal     = mapper.countUsersTotal();
        long usersYesterday = mapper.countUsersOnDate(sYesterday);
        long usersToday     = mapper.countUsersOnDate(sToday);
        long inboundToday   = mapper.countInboundOnDate(sToday);
        long outboundToday  = mapper.countOutboundOnDate(sToday);

        // 월간 KPI (이번달/저번달)
        LocalDate startThisMonth = today.withDayOfMonth(1);
        LocalDate startNextMonth = startThisMonth.plusMonths(1);
        LocalDate startPrevMonth = startThisMonth.minusMonths(1);

        // MySQL DATETIME 비교이므로 'YYYY-MM-DD HH:MM:SS' 형식으로 전달
        String thisStart = startThisMonth.toString() + " 00:00:00";
        String nextStart = startNextMonth.toString() + " 00:00:00";
        String prevStart = startPrevMonth.toString() + " 00:00:00";

        long usersThisMonth = mapper.countUsersBetween(thisStart, nextStart);
        long usersPrevMonth = mapper.countUsersBetween(prevStart, thisStart);

        // 차트(일 단위)
        List<LocalDate> labels = new ArrayList<>(days);
        List<Long> usersDaily  = new ArrayList<>(days);
        List<Long> inDaily     = new ArrayList<>(days);
        List<Long> outDaily    = new ArrayList<>(days);

        for (LocalDate d = start; !d.isAfter(today); d = d.plusDays(1)) {
            String ds = d.toString(); // "YYYY-MM-DD"
            labels.add(d);
            usersDaily.add(safeCount(() -> mapper.countUsersOnDate(ds)));
            inDaily.add(safeCount(() -> mapper.countInboundOnDate(ds)));
            outDaily.add(safeCount(() -> mapper.countOutboundOnDate(ds)));
        }

        DashBoardSummaryDTO dto = new DashBoardSummaryDTO();
        dto.setUsersTotal(usersTotal);
        dto.setUsersYesterday(usersYesterday);
        dto.setUsersToday(usersToday);
        dto.setUsersDelta(usersToday - usersYesterday);
        dto.setInboundToday(inboundToday);
        dto.setOutboundToday(outboundToday);

        // 월간 KPI 세팅
        dto.setUsersThisMonth(usersThisMonth);
        dto.setUsersPrevMonth(usersPrevMonth);

        dto.setLabels(labels);
        dto.setUsersDaily(usersDaily);
        dto.setInboundDaily(inDaily);
        dto.setOutboundDaily(outDaily);
        return dto;
    }

    private long safeCount(java.util.function.Supplier<Long> s) {
        try { Long v = s.get(); return (v == null) ? 0L : v; }
        catch (Exception e) { return 0L; }
    }
}


