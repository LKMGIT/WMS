package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import com.ssg.wms.inbound.mappers.InboundMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 입고 관리 서비스 구현 클래스
 */
@Service
@Transactional
public class InboundServiceImpl implements InboundService {

    @Autowired
    private InboundMapper inboundMapper;

    // ============================================
    // 입고 요청 관련 메서드
    // ============================================

    /**
     * 입고 요청 등록
     */
    @Override
    public Long requestInbound(InboundRequestDTO requestDTO, Long userId) {
        requestDTO.setUserIndex(userId);
        inboundMapper.insertRequest(requestDTO);
        return requestDTO.getInboundIndex();
    }

    /**
     * 입고 요청 목록 조회
     */
    @Override
    public List<InboundRequestDTO> getRequests(String keyword, String status, Long userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("status", status);
        params.put("userId", userId);
        return inboundMapper.selectRequests(params);
    }

    /**
     * 입고 요청 취소
     */
    @Override
    public boolean cancelRequest(Long requestIndex, String cancelReason, Long userId) {
        // 권한 체크 (본인의 요청인지 확인)
        InboundRequestDTO request = inboundMapper.selectRequestById(requestIndex);
        if (request == null || !request.getUserIndex().equals(userId)) {
            return false;
        }

        // 이미 승인되었거나 취소된 요청은 취소 불가
        if (!"PENDING".equals(request.getApprovalStatus())) {
            return false;
        }

        InboundRequestDTO dto = new InboundRequestDTO();
        dto.setInboundIndex(requestIndex);
        dto.setCancelReason(cancelReason);

        return inboundMapper.updateCancel(dto) > 0;
    }

    /**
     * 입고 요청 수정
     */
    @Override
    public boolean updateRequest(InboundRequestDTO requestDTO) {
        // 승인 대기 상태일 때만 수정 가능
        InboundRequestDTO existing = inboundMapper.selectRequestById(requestDTO.getInboundIndex());
        if (existing == null || !"PENDING".equals(existing.getApprovalStatus())) {
            return false;
        }

        return inboundMapper.updateRequest(requestDTO) > 0;
    }

    /**
     * 기간별 입고 현황 조회
     */
    @Override
    public List<InboundRequestDTO> getInboundStatusByPeriod(String startDate, String endDate, Long userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        params.put("userId", userId);
        return inboundMapper.selectInboundStatusByPeriod(params);
    }

    /**
     * 월별 입고 현황 조회
     */
    @Override
    public List<InboundRequestDTO> getInboundStatusByMonth(int year, int month) {
        return inboundMapper.selectInboundStatusByMonth(year, month);
    }


    // ============================================
    // 입고 상세 관련 메서드
    // ============================================

    /**
     * 입고 요청 상세 조회 (입고 요청 + 상세 목록)
     */
    @Override
    public InboundRequestDTO getRequestWithDetails(Long requestIndex) {
        InboundRequestDTO request = inboundMapper.selectRequestById(requestIndex);
        if (request != null) {
            List<InboundDetailDTO> details = inboundMapper.selectDetailsByRequestId(requestIndex);
            request.setDetails(details);
        }
        return request;
    }

    /**
     * 입고 요청 삭제
     */
    @Override
    public boolean deleteRequest(Long requestIndex) {
        // 승인 전 요청만 삭제 가능
        InboundRequestDTO request = inboundMapper.selectRequestById(requestIndex);
        if (request == null || "APPROVED".equals(request.getApprovalStatus())) {
            return false;
        }

        return inboundMapper.deleteRequest(requestIndex) > 0;
    }


    // ============================================
    // 관리자 전용 메서드
    // ============================================

    /**
     * 입고 요청 승인 (관리자)
     */
    @Override
    public boolean approveRequest(Long requestIndex, Long adminId) {
        InboundRequestDTO request = inboundMapper.selectRequestById(requestIndex);
        if (request == null || !"PENDING".equals(request.getApprovalStatus())) {
            return false;
        }

        return inboundMapper.updateApproval(requestIndex) > 0;
    }

    /**
     * 입고 상세 위치 지정 (관리자)
     */
    @Override
    public boolean updateLocation(Integer detailIndex, String location, Long adminId) {
        InboundDetailDTO detailDTO = new InboundDetailDTO();
        detailDTO.setDetailIndex(detailIndex);
        detailDTO.setLocation(location);

        return inboundMapper.updateDetail(detailDTO) > 0;
    }

    /**
     * QR 코드 생성 및 지정 (관리자)
     */
    @Override
    public String generateQrCode(Integer detailIndex, Long adminId) {
        // QR 코드 값 생성 (예: INB-DETAIL-{detailIndex})
        String qrCode = "INB-DETAIL-" + detailIndex;

        // DB에 저장
        InboundDetailDTO detailDTO = new InboundDetailDTO();
        detailDTO.setDetailIndex(detailIndex);
        detailDTO.setQrCode(qrCode);

        inboundMapper.updateDetail(detailDTO);

        return qrCode;
    }

    /**
     * QR 코드로 입고 상세 조회
     */
    @Override
    public InboundDetailDTO getDetailByQr(String qrCode) {
        return inboundMapper.selectDetailByQr(qrCode);
    }

    /**
     * 입고 상세 완료 처리 (관리자)
     */
    @Override
    public boolean completeInbound(Integer detailIndex, Integer receivedQuantity, Long adminId) {
        InboundDetailDTO detailDTO = new InboundDetailDTO();
        detailDTO.setDetailIndex(detailIndex);
        detailDTO.setReceivedQuantity(receivedQuantity);

        return inboundMapper.updateComplete(detailDTO) > 0;
    }

    /**
     * 관리자용 입고 요청 목록 조회
     */
    @Override
    public List<InboundRequestDTO> getAdminInboundRequests(String keyword, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("status", status);
        params.put("userId", null); // 관리자는 모든 요청 조회
        return inboundMapper.selectRequests(params);
    }
}
