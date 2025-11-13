package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inbound.domain.InboundRequestDTO;
import com.ssg.wms.inbound.mappers.InboundMapper;
import com.ssg.wms.inventory.service.InvenService;
import com.ssg.wms.warehouse.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
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

        // --- 0단계: 원본 요청 정보 로드 및 상세 내역 검증/생성 ---
        InboundRequestDTO originalRequest = inboundMapper.selectRequestById(requestDTO.getInboundIndex());
        if (originalRequest == null) {
            throw new RuntimeException("원본 입고 요청을 찾을 수 없습니다: " + requestDTO.getInboundIndex());
        }

        List<InboundDetailDTO> details = requestDTO.getDetails();
        InboundDetailDTO detailToProcess;

        // 클라이언트에서 상세 내역(details)이 넘어오지 않은 경우 (최초 승인 시)
        if (details == null || details.isEmpty()) {

            // 4단계: requestDTO의 값을 통해 detailDTO 생성 (여기서는 originalRequest 사용)
            detailToProcess = InboundDetailDTO.builder()
                    .inboundIndex(requestDTO.getInboundIndex())
                    .receivedQuantity(0L) // 승인 시에는 0으로 초기화
                    .warehouseIndex(originalRequest.getWarehouseIndex().longValue())
                    .sectionIndex(null) // 🔥 수정: Long 타입이므로 null을 사용 (XML에서 처리)
                    .build();

            // requestDTO에 상세 내역을 다시 설정하여 후속 로직에서 사용
            requestDTO.setDetails(Collections.singletonList(detailToProcess));
            requestDTO.setWarehouseIndex(originalRequest.getWarehouseIndex()); // 원본 창고 정보 설정
            requestDTO.setItem_index(originalRequest.getItem_index()); // 원본 아이템 정보 설정
        } else {
            // 클라이언트가 상세 내역을 보내온 경우
            detailToProcess = details.get(0);
        }

        // --- 1단계: item_index를 통해 item_volume 받아오기 ---
        Long itemIndex = originalRequest.getItem_index();

        // int itemVolume = itemService.getItemVolume(itemIndex);
        int itemVolume = 1; // 🚨 임시 부피

        // --- 2단계: canInbound() 검증 (승인 단계에서는 재고 공간 검증을 건너뜁니다.) ---

        // --- 3단계: 입고 요청 승인으로 변경 (PENDING -> APPROVED) ---
        int result = inboundMapper.updateApproval(requestDTO.getInboundIndex());
        if (result == 0) {
            throw new RuntimeException("입고 요청 승인 실패 (ID: " + requestDTO.getInboundIndex() + ") - 이미 승인되었거나 존재하지 않는 요청입니다.");
        }

        // --- 4단계 (재사용): detailToProcess 필드 값 재설정 ---
        detailToProcess.setInboundIndex(requestDTO.getInboundIndex());
        detailToProcess.setWarehouseIndex(originalRequest.getWarehouseIndex().longValue());
        detailToProcess.setReceivedQuantity(0L);
        detailToProcess.setSectionIndex(null); // 🔥 수정: Long 타입이므로 null을 사용 (XML에서 처리)

        // --- 5단계: DB에 상세 내역(미처리 상태) INSERT만 수행 ---
        inboundMapper.insertInboundDetail(detailToProcess);

        // invenService.applyInbound(detailToProcess); // receivedQuantity=0 이므로 재고 반영하지 않음
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

        // DTO 필드가 Long이므로, String으로 변환이 필요하다면 여기서 처리해야 합니다.
        // 현재는 SectionIndex가 Long이므로, 실제 Section 코드가 아닌 ID가 넘어온다고 가정합니다.

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