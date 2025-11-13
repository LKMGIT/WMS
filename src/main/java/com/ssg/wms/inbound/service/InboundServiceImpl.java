package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import com.ssg.wms.inbound.mappers.InboundMapper;
import com.ssg.wms.inventory.service.InvenService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class InboundServiceImpl implements InboundService {

    private final InboundMapper inboundMapper;
    private final InvenService invenService;

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

    @Transactional // (readOnly = false)
    @Override
    public void cancelRequest(InboundRequestDTO requestDTO) {
        int result = inboundMapper.updateCancel(requestDTO);
        if (result == 0) {
            throw new RuntimeException("입고 요청 취소 실패 (ID: " + requestDTO.getInboundIndex() + ")");
        }
    }

    @Transactional // (readOnly = false)
    @Override
    public void approveRequest(Long inboundIndex) {
        int result = inboundMapper.updateApproval(inboundIndex);
        if (result == 0) {
            throw new RuntimeException("입고 요청 승인 실패 (ID: " + inboundIndex + ")");
        }
    }

    /**
     * (신규) 실제 입고 처리 (위치, 수량 업데이트)
     * '입고' 파트의 책임은 'inbound_detail' 테이블에
     * 입고 위치, 수량, 날짜를 정확히 기록하는 것입니다.
     */
    @Transactional // (readOnly = false)
    @Override
    public void processInboundDetail(InboundDetailDTO detailDTO) throws Exception {

        // 1. 상세 내역 업데이트 (수량, 날짜, 위치)
        int result = inboundMapper.updateInboundDetail(detailDTO);

        invenService.applyInbound(detailDTO);

        if (result == 0) {
            throw new RuntimeException("입고 처리 실패: " + detailDTO.getDetailIndex());
        }

        // 재고(Stock) 테이블을 직접 수정하는 로직은
        // '재고' 모듈이 담당하므로 여기서는 제외됩니다.
    }

    /**
     * (신규) 기간별 통계
     */
    @Override
    public List<InboundRequestDTO> getStatsByPeriod(Map<String, Object> params) {
        return inboundMapper.selectInboundStatusByPeriod(params);
    }

    /**
     * (신규) 월별 통계
     */
    @Override
    public List<InboundRequestDTO> getStatsByMonth(int year, int month) {
        return inboundMapper.selectInboundStatusByMonth(year, month);
    }
}