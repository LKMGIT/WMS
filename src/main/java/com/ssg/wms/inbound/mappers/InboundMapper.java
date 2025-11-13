package com.ssg.wms.inbound.mappers;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface InboundMapper {

    // ===== 입고 요청(Request) 관리 =====
    InboundRequestDTO selectRequestById(@Param("inbound_index") Long inboundIndex);
    List<InboundRequestDTO> selectAllRequests(Map<String, Object> params);
    int countRequests(Map<String, Object> params);

    // ===== 입고 상태(Status) 변경 =====
    int updateCancel(InboundRequestDTO requestDTO);
    int updateApproval(@Param("request_index") Long requestIndex);

    // ===== 실제 입고 처리 =====

    // 🔥 [신규 추가] 5단계: DB에 저장
    int insertInboundDetail(InboundDetailDTO detailDTO);

    int updateInboundDetail(InboundDetailDTO detailDTO);

    // ===== 통계 현황 =====
    List<InboundRequestDTO> selectInboundStatusByPeriod(Map<String, Object> params);
    List<InboundRequestDTO> selectInboundStatusByMonth(@Param("year") int year, @Param("month") int month);
}