package com.ssg.wms.inbound.mappers;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface InboundMapper {

    // ============================================
    // 입고 요청 관련 메서드
    // ============================================

    /** 입고 요청 등록 */
    int insertRequest(InboundRequestDTO requestDTO);

    /** 입고 요청 단건 조회 */
    InboundRequestDTO selectRequestById(@Param("inbound_index") Long inboundIndex);

    /** 입고 요청 목록 조회 (검색 조건 포함) */
    List<InboundRequestDTO> selectRequests(Map<String, Object> params);

    /** 입고 요청 수정 */
    int updateRequest(InboundRequestDTO requestDTO);

    /** 입고 요청 삭제  */
    int deleteRequest(@Param("request_index") Long requestIndex);

    /** 입고 요청 취소 */
    int updateCancel(InboundRequestDTO requestDTO);

    /** 입고 요청 승인 */
    int updateApproval(@Param("request_index") Long requestIndex);

    /** 기간별 입고 현황 조회 */
    List<InboundRequestDTO> selectInboundStatusByPeriod(Map<String, Object> params);

    /** 월별 입고 현황 조회 */
    List<InboundRequestDTO> selectInboundStatusByMonth(@Param("year") int year, @Param("month") int month);


    /** 입고 상세 추가 */
    int insertDetail(InboundDetailDTO detailDTO);

    /** 요청번호로 입고 상세 목록 조회 */
    List<InboundDetailDTO> selectDetailsByRequestId(@Param("request_index") Long requestIndex);

    /** QR코드로 입고 상세 조회 */
    InboundDetailDTO selectDetailByQr(@Param("qr_code") String qrCode);

    /** 입고 상세 수정 */
    int updateDetail(InboundDetailDTO detailDTO);

    /** 입고 상세 완료 처리 */
    int updateComplete(InboundDetailDTO detailDTO);

    /** 입고 상세 삭제  */
    int deleteDetail(@Param("detail_index") Integer detailIndex);
}
