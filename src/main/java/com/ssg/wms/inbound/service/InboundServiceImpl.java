package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import com.ssg.wms.inbound.mappers.InboundMapper;
import com.ssg.wms.inventory.service.InvenService; // 재고 파트 연동
import com.ssg.wms.warehouse.service.WarehouseService; // 창고 관련 서비스
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Log4j2
public class InboundServiceImpl implements InboundService {

    private final InboundMapper inboundMapper;
    private final InvenService invenService;
    private final WarehouseService warehouseService;

    @Override
    public InboundRequestDTO getRequestById(Long inboundIndex) {
        return inboundMapper.selectRequestById(inboundIndex);
    }

    @Override
    public List<InboundRequestDTO> getRequestList(Map<String, Object> params) {
        return inboundMapper.selectAllRequests(params);
    }

    @Override
    public int getRequestCount(Map<String, Object> params) {
        return inboundMapper.countRequests(params);
    }

    @Transactional
    @Override
    public void cancelRequest(InboundRequestDTO requestDTO) {
        int result = inboundMapper.updateCancel(requestDTO);
        if (result == 0) {
            throw new RuntimeException("입고 요청 취소 실패: " + requestDTO.getInboundIndex());
        }
    }

    /**
     * 입고 요청 승인: 구역 배정 및 단일 상세 내역 생성
     */
    @Transactional
    @Override
    public void approveRequest(InboundRequestDTO requestDTO) throws Exception {
        Long requestIndex = requestDTO.getInboundIndex();

        // 1. 요청 상태를 APPROVED로 변경
        int requestUpdateResult = inboundMapper.updateApproval(requestIndex);
        if (requestUpdateResult == 0) {
            throw new RuntimeException("입고 요청 승인 실패: " + requestIndex + "를 찾을 수 없거나 상태를 변경할 수 없습니다.");
        }

        // 2. 창고 번호 및 구역 정보 추출
        Integer existingWarehouseIndex = requestDTO.getWarehouseIndex(); // 기존 창고 번호

        // DTO에 임시로 실어온 구역 인덱스 (detail.jsp에서 cancelReason 필드에 담아 보냈음)
        Long selectedSectionIndex = null;
        try {
            if (requestDTO.getCancelReason() != null && !requestDTO.getCancelReason().isEmpty()) {
                selectedSectionIndex = Long.valueOf(requestDTO.getCancelReason());
            }
        } catch (NumberFormatException | NullPointerException e) { // 🔥 예외 처리 강화
            throw new RuntimeException("구역 코드는 Long 타입 숫자여야 합니다: " + e.getMessage());
        }

        // 3. inbound_detail 레코드를 단 하나만 생성
        InboundDetailDTO detailDTO = new InboundDetailDTO();
        detailDTO.setInboundIndex(requestIndex);
        detailDTO.setWarehouseIndex(existingWarehouseIndex.longValue());
        detailDTO.setReceivedQuantity(0L);
        detailDTO.setSectionIndex(selectedSectionIndex); // 🔥 선택된 구역 인덱스 즉시 반영

        inboundMapper.insertInboundDetail(detailDTO); // 단 1회 삽입
    }

    /**
     * 입고 상세 내역 수정: 재고 반영 로직 활성화 (용량 체크 제거)
     */
    @Transactional
    @Override
    public void processInboundDetail(InboundDetailDTO detailDTO) throws Exception {

        if (detailDTO.getWarehouseIndex() == null) {
            throw new RuntimeException("입고 상세 처리 실패: 창고 번호(warehouseIndex)가 누락되었습니다.");
        }

        // 창고 용량 검사 로직 제거

        int result = inboundMapper.updateInboundDetail(detailDTO);
        if (result == 0) {
            throw new RuntimeException("입고 처리(수정) 실패: " + detailDTO.getDetailIndex());
        }


        // 재고 파트로 데이터 반영
//        invenService.applyInbound(detailDTO);
    }

    // --- 통계 메서드 (기존과 동일) ---
    @Override
    public List<InboundRequestDTO> getStatsByPeriod(Map<String, Object> params) {
        return inboundMapper.selectInboundStatusByPeriod(params);
    }

    @Override
    public List<InboundRequestDTO> getStatsByMonth(int year, int month) {
        return inboundMapper.selectInboundStatusByMonth(year, month);
    }
}