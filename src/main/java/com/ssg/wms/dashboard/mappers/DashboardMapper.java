// src/main/java/com/ssg/wms/dashboard/mappers/DashboardMapper.java
package com.ssg.wms.dashboard.mappers;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardMapper {
    long countUsersTotal();

    // 일 단위
    long countUsersOnDate(@Param("day") String day);
    long countInboundOnDate(@Param("day") String day);
    long countOutboundOnDate(@Param("day") String day);

    // 월간 가입 카운트 (반열림 [start,end) )
    long countUsersBetween(@Param("start") String startIsoDateTime,
                           @Param("end")   String endIsoDateTime);

    // 월 단위 집계 (최근 12개월) — ym: YYYY-MM, cnt: LONG
    List<Map<String,Object>> selectInboundMonthly(@Param("start") String startInclusive,
                                                  @Param("end")   String endExclusive);
    List<Map<String,Object>> selectOutboundMonthly(@Param("start") String startInclusive,
                                                   @Param("end")   String endExclusive);

    long countInboundBetween(@Param("start") String startIsoDateTime,
                             @Param("end")   String endIsoDateTime);

    long countOutboundBetween(@Param("start") String startIsoDateTime,
                              @Param("end")   String endIsoDateTime);

}
