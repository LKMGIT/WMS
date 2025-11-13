package com.ssg.wms.dashboard.mappers;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;

// com.ssg.wms.dashboard.mappers.DashboardMapper
@Mapper
public interface DashboardMapper {
    long countUsersTotal();

    // 일 단위 기존 메서드 (차트용)
    long countUsersOnDate(@Param("day") String day);
    long countInboundOnDate(@Param("day") String day);
    long countOutboundOnDate(@Param("day") String day);

    // ⬇️ 월간 구간 카운트 ( [start, end) 반열림 )
    long countUsersBetween(@Param("start") String startIsoDateTime,
                           @Param("end")   String endIsoDateTime);
}

