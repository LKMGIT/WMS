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

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardServiceImpl implements DashboardService {

    private final DashboardMapper mapper;

    // com.ssg.wms.dashboard.service.DashboardServiceImpl
    @Override
    public DashBoardSummaryDTO getSummaryLast7Days() {
        LocalDate today = LocalDate.now();
        LocalDate start = today.minusDays(6);

        String sToday     = today.toString();                 // "YYYY-MM-DD"
        String sYesterday = today.minusDays(1).toString();

        long usersTotal     = mapper.countUsersTotal();
        long usersYesterday = mapper.countUsersOnDate(sYesterday);
        long usersToday     = mapper.countUsersOnDate(sToday);
        long inboundToday   = mapper.countInboundOnDate(sToday);
        long outboundToday  = mapper.countOutboundOnDate(sToday);

        List<LocalDate> labels = new ArrayList<>(7);
        List<Long> usersDaily  = new ArrayList<>(7);
        List<Long> inDaily     = new ArrayList<>(7);
        List<Long> outDaily    = new ArrayList<>(7);

        for(LocalDate d = start; !d.isAfter(today); d = d.plusDays(1)) {
            String ds = d.toString();
            labels.add(d);
            usersDaily.add(mapper.countUsersOnDate(ds));
            inDaily.add(mapper.countInboundOnDate(ds));
            outDaily.add(mapper.countOutboundOnDate(ds));
        }

        DashBoardSummaryDTO dto = new DashBoardSummaryDTO();
        dto.setUsersTotal(usersTotal);
        dto.setUsersYesterday(usersYesterday);
        dto.setUsersToday(usersToday);
        dto.setUsersDelta(usersToday - usersYesterday);
        dto.setInboundToday(inboundToday);
        dto.setOutboundToday(outboundToday);
        dto.setLabels(labels);
        dto.setUsersDaily(usersDaily);
        dto.setInboundDaily(inDaily);
        dto.setOutboundDaily(outDaily);
        return dto;
    }

}
