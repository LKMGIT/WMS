package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;

import java.util.List;
import java.util.Map;

public interface InboundService {

    // ===== 입고 요청(Request) 관리 =====
    InboundRequestDTO getRequestById(Long inboundIndex);
    List<InboundRequestDTO> getRequestList(Map<String, Object> params);
    int getRequestCount(Map<String, Object> params);

    // ===== 입고 상태(Status) 변경 =====
    void cancelRequest(InboundRequestDTO requestDTO);

    /**
     * 구역 정보만 받아서 승인 처리
     */
    void approveRequest(InboundRequestDTO requestDTO) throws Exception;

    /**
     * 수정
     */
    void processInboundDetail(InboundDetailDTO detailDTO) throws Exception;

    // ===== 통계 현황 =====
    List<InboundRequestDTO> getStatsByPeriod(Map<String, Object> params);
    List<InboundRequestDTO> getStatsByMonth(int year, int month);
}