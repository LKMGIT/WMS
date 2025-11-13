package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import java.util.List;

public interface InboundService {

    /**입고 요청 등록 */
    Long requestInbound(InboundRequestDTO requestDTO, Long userId);

    /**입고 요청 목록 조회*/
    List<InboundRequestDTO> getRequests(String keyword, String status, Long userId);

    /** 입고 요청 취소 */
    boolean cancelRequest(Long requestIndex, String cancelReason, Long userId);

    /** 입고 요청 수정 */
    boolean updateRequest(InboundRequestDTO requestDTO);

    /** 기간별 입고 현황 조회 */
    List<InboundRequestDTO> getInboundStatusByPeriod(String startDate, String endDate, Long userId);

    /** 월별 입고 현황 조회 */
    List<InboundRequestDTO> getInboundStatusByMonth(int year, int month);

    /** 입고 요청 상세 조회 (입고 요청 + 상세 목록) */
    InboundRequestDTO getRequestWithDetails(Long requestIndex);

    /** 입고 요청 삭제 */
    boolean deleteRequest(Long requestIndex);

    //관리자 전용 메서드
    /** 입고 요청 승인 (관리자) */
    boolean approveRequest(Long requestIndex, Long adminId);

    /** 입고 상세 위치 지정 (관리자) */
    boolean updateLocation(Long detailIndex, String location, Long adminId);

    /** QR 코드 생성 및 지정 (관리자) */
    String generateQrCode(Long detailIndex, Long adminId);

    /** QR 코드로 입고 상세 조회 */
    InboundDetailDTO getDetailByQr(String qrCode);

    /** 입고 상세 완료 처리 (관리자) */
    boolean completeInbound(Long detailIndex, Long receivedQuantity, Long adminId);

    /** 관리자용 입고 요청 목록 조회 (list.jsp) */
    List<InboundRequestDTO> getAdminInboundRequests(String keyword, String status);

    /** 관리자용 입고 (상세) 목록 조회 (form.jsp) */
    List<InboundDetailDTO> getAdminInboundDetails(String keyword, String status);
}