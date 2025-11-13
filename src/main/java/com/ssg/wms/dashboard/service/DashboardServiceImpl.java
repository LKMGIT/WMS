// src/main/java/com/ssg/wms/dashboard/service/DashboardServiceImpl.java
package com.ssg.wms.dashboard.service;

import com.ssg.wms.dashboard.domain.DashBoardSummaryDTO;
import com.ssg.wms.dashboard.mappers.DashboardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Supplier;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardServiceImpl implements DashboardService {

    private final DashboardMapper mapper;

    @Override
    public DashBoardSummaryDTO getSummary(String range) {
        final int days = ("30d".equalsIgnoreCase(range)) ? 30 : 7;

        LocalDate today = LocalDate.now();
        LocalDate start = today.minusDays(days - 1);

        String sToday     = today.toString();
        String sYesterday = today.minusDays(1).toString();

        long usersTotal     = mapper.countUsersTotal();
        long usersYesterday = mapper.countUsersOnDate(sYesterday);
        long usersToday     = mapper.countUsersOnDate(sToday);
        long inboundToday   = mapper.countInboundOnDate(sToday);
        long outboundToday  = mapper.countOutboundOnDate(sToday);

        List<LocalDate> labels = new ArrayList<>(days);
        List<Long> usersDaily  = new ArrayList<>(days);
        List<Long> inDaily     = new ArrayList<>(days);
        List<Long> outDaily    = new ArrayList<>(days);

        for (LocalDate d = start; !d.isAfter(today); d = d.plusDays(1)) {
            String ds = d.toString();
            labels.add(d);
            usersDaily.add(safeCount(() -> mapper.countUsersOnDate(ds)));
            inDaily.add(safeCount(() -> mapper.countInboundOnDate(ds)));
            outDaily.add(safeCount(() -> mapper.countOutboundOnDate(ds)));
        }

        // ===== 월간 KPI (저번달/이번달 가입) =====
        YearMonth thisMonth  = YearMonth.from(today);
        YearMonth prevMonth  = thisMonth.minusMonths(1);

        LocalDateTime prevStart = prevMonth.atDay(1).atStartOfDay();
        LocalDateTime prevEnd   = thisMonth.atDay(1).atStartOfDay();           // 반열림
        LocalDateTime thisStart = thisMonth.atDay(1).atStartOfDay();
        LocalDateTime thisEnd   = thisMonth.plusMonths(1).atDay(1).atStartOfDay();

        DateTimeFormatter TS = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        long usersPrevMonth = mapper.countUsersBetween(prevStart.format(TS), prevEnd.format(TS));
        long usersThisMonth = mapper.countUsersBetween(thisStart.format(TS), thisEnd.format(TS));

        // ===== 월별 입/출고 (최근 12개월) =====
        YearMonth startYm = thisMonth.minusMonths(11);
        LocalDateTime monthStart = startYm.atDay(1).atStartOfDay();
        LocalDateTime monthEnd   = thisMonth.plusMonths(1).atDay(1).atStartOfDay(); // 다음달 1일

        List<String> monthLabels = new ArrayList<>(12);
        Map<String, Long> inMap  = new HashMap<>();
        Map<String, Long> outMap = new HashMap<>();

        DateTimeFormatter YM = DateTimeFormatter.ofPattern("yyyy-MM");

        // 라벨 미리 12개 생성 (0 채우기용)
        YearMonth cursor = startYm;
        for (int i = 0; i < 12; i++) {
            monthLabels.add(cursor.format(YM));
            cursor = cursor.plusMonths(1);
        }

        // DB에서 월별 집계 결과 조회
        List<Map<String, Object>> inRows = mapper.selectInboundMonthly(monthStart.format(TS), monthEnd.format(TS));
        for (Map<String, Object> r : inRows) {
            String ym = Objects.toString(r.get("ym"), "");
            Long cnt  = castLong(r.get("cnt"));
            inMap.put(ym, cnt != null ? cnt : 0L);
        }
        List<Map<String, Object>> outRows = mapper.selectOutboundMonthly(monthStart.format(TS), monthEnd.format(TS));
        for (Map<String, Object> r : outRows) {
            String ym = Objects.toString(r.get("ym"), "");
            Long cnt  = castLong(r.get("cnt"));
            outMap.put(ym, cnt != null ? cnt : 0L);
        }

        List<Long> inboundMonthly  = new ArrayList<>(12);
        List<Long> outboundMonthly = new ArrayList<>(12);
        for (String ym : monthLabels) {
            inboundMonthly.add(inMap.getOrDefault(ym, 0L));
            outboundMonthly.add(outMap.getOrDefault(ym, 0L));
        }

        LocalDate first = LocalDate.now().withDayOfMonth(1);
        LocalDate next  = first.plusMonths(1);

        long inboundThisMonth  = mapper.countInboundBetween(first.atStartOfDay().toString(),
                next.atStartOfDay().toString());
        long outboundThisMonth = mapper.countOutboundBetween(first.atStartOfDay().toString(),
                next.atStartOfDay().toString());


        
        // ===== DTO 채워서 반환 =====
        DashBoardSummaryDTO dto = new DashBoardSummaryDTO();
        dto.setUsersTotal(usersTotal);
        dto.setUsersYesterday(usersYesterday);
        dto.setUsersToday(usersToday);
        dto.setUsersDelta(usersToday - usersYesterday);
        dto.setInboundToday(inboundToday);
        dto.setOutboundToday(outboundToday);

        dto.setUsersPrevMonth(usersPrevMonth);
        dto.setUsersThisMonth(usersThisMonth);

        dto.setLabels(labels);
        dto.setUsersDaily(usersDaily);
        dto.setInboundDaily(inDaily);
        dto.setOutboundDaily(outDaily);

        dto.setMonthLabels(monthLabels);
        dto.setInboundMonthly(inboundMonthly);
        dto.setOutboundMonthly(outboundMonthly);

        dto.setInboundThisMonth(inboundThisMonth);
        dto.setOutboundThisMonth(outboundThisMonth);

        return dto;
    }

    private long safeCount(Supplier<Long> s) {
        try {
            Long v = s.get();
            return (v == null) ? 0L : v;
        } catch (Exception e) {
            return 0L;
        }
    }

    private Long castLong(Object o) {
        if (o == null) return null;
        if (o instanceof Long) return (Long) o;
        if (o instanceof Integer) return ((Integer) o).longValue();
        if (o instanceof Number) return ((Number) o).longValue();
        return Long.valueOf(o.toString());
    }
}
