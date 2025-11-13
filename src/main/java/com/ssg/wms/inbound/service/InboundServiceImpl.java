package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import com.ssg.wms.inbound.mappers.InboundMapper;
import com.ssg.wms.inventory.service.InvenService;
import com.ssg.wms.warehouse.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2; // 🔥 [수정] Log4j2 임포트
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Log4j2 // 🔥 [수정] 로그 사용 선언
public class InboundServiceImpl implements InboundService {

    private final InboundMapper inboundMapper;
    private final InvenService invenService;
    private final WarehouseService warehouseService;

    // private final ItemService itemService;

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
            throw new RuntimeException("입고 요청 취소 실패 (ID: " + requestDTO.getInboundIndex() + ")");
        }
    }

    /**
     * 🔥 [수정된 로직] 5단계 흐름을 구현한 '승인 및 처리' 메서드
     */
    @Transactional
    @Override
    public void approveRequest(InboundRequestDTO requestDTO) throws Exception {

        // --- 0단계: DTO 유효성 검증 ---
        List<InboundDetailDTO> details = requestDTO.getDetails();

        // 🔥 [수정] 디버그 로그 추가
        log.info("===[Inbound Approve] Request Index: {}", requestDTO.getInboundIndex());
        log.info("===[Inbound Approve] Details received: {}", details);
        // 🔥 만약 details가 null이거나 비어있다면, JSON 데이터 전송 오류일 가능성이 높습니다.

        if (details == null || details.isEmpty()) {
            throw new IllegalArgumentException("처리할 상세 입고 내역이 없습니다. (Details List is Empty/Null)");
        }
        InboundDetailDTO detailToProcess = details.get(0);

        // --- 1단계: item_index를 통해 item_volume 받아오기 ---
        Long itemIndex = requestDTO.getItem_index();
        if (itemIndex == null) {
            InboundRequestDTO originalRequest = inboundMapper.selectRequestById(requestDTO.getInboundIndex());
            if (originalRequest == null) {
                throw new RuntimeException("원본 입고 요청을 찾을 수 없습니다: " + requestDTO.getInboundIndex());
            }
            itemIndex = originalRequest.getItem_index();
        }

        // int itemVolume = itemService.getItemVolume(itemIndex);
        int itemVolume = 1; // 🚨 임시 부피 (반드시 수정)

        // --- 2단계: canInbound()에 전달 및 검증 ---
        int quantity = Math.toIntExact(detailToProcess.getReceivedQuantity());
        Long sectionIndex = detailToProcess.getSectionIndex();

        if (sectionIndex == null) {
            throw new IllegalArgumentException("구역(Section) 정보가 없습니다.");
        }

        boolean canInbound = warehouseService.canInbound(sectionIndex, itemVolume, quantity);

        if (!canInbound) {
            int remain = warehouseService.calculateSectionRemain(sectionIndex);
            throw new Exception(
                    String.format("재고 공간 부족: 구역(%d) (필요: %d, 남은 공간: %d)",
                            sectionIndex, (itemVolume * quantity), remain)
            );
        }

        // --- 3단계: 적재 가능 시 입고 요청 승인으로 변경 ---
        int result = inboundMapper.updateApproval(requestDTO.getInboundIndex());
        if (result == 0) {
            throw new RuntimeException("입고 요청 승인 실패 (ID: " + requestDTO.getInboundIndex() + ")");
        }

        // --- 4단계: requestDTO의 값을 통해 detailDTO 생성 ---
        detailToProcess.setInboundIndex(requestDTO.getInboundIndex());
        if (detailToProcess.getWarehouseIndex() == null) {
            detailToProcess.setWarehouseIndex(requestDTO.getWarehouseIndex().longValue());
        }

        // --- 5단계: DB에 저장(INSERT) 후 applyInbound()에 전달 ---
        inboundMapper.insertInboundDetail(detailToProcess);
        invenService.applyInbound(detailToProcess);
    }

    /**
     * (참고) 이 메서드는 '승인' 이후, 상세 내역을 '수정'할 때 사용됩니다.
     */
    @Transactional
    @Override
    public void processInboundDetail(InboundDetailDTO detailDTO) throws Exception {

        int quantity = Math.toIntExact(detailDTO.getReceivedQuantity());
        Long sectionIndex = detailDTO.getSectionIndex();
        int itemVolume = 1; // 🚨 임시 부피 (필수 수정)

        boolean canInbound = warehouseService.canInbound(sectionIndex, itemVolume, quantity);
        if (!canInbound) {
            int remain = warehouseService.calculateSectionRemain(sectionIndex);
            throw new Exception(
                    String.format("재고 공간 부족(수정): 구역(%d) (필요: %d, 남은 공간: %d)",
                            sectionIndex, (itemVolume * quantity), remain)
            );
        }

        int result = inboundMapper.updateInboundDetail(detailDTO);
        if (result == 0) {
            throw new RuntimeException("입고 처리(수정) 실패: " + detailDTO.getDetailIndex());
        }

        invenService.applyInbound(detailDTO);
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