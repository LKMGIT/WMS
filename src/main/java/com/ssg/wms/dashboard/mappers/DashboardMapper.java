package com.ssg.wms.dashboard.mappers;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;

@Mapper
public interface DashboardMapper {
    long countUsersTotal();
    long countUsersOnDate(@Param("day") String day);
    long countInboundOnDate(@Param("day") String day);
    long countOutboundOnDate(@Param("day") String day);
}
