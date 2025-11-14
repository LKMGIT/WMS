package com.ssg.wms.inventory.service;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inventory.domain.InvenDTO;
import com.ssg.wms.inventory.domain.InvenItemViewDTO;
import com.ssg.wms.inventory.mappers.InvenMapper;
import com.ssg.wms.outbound.domain.ShippingInstructionDetailDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class InvenServiceImpl implements InvenService {

    private final InvenMapper inventoryMapper;

    private static final Set<String> ITEM_CATEGORIES =
            Set.of("HEALTH","BEAUTY","PERFUME","CARE","FOOD");

    private static void normalizeAndValidate(Criteria cri) {
        String cat = cri.getCategory();

        if (cat == null) {
            return;
        }

        // 앞뒤 공백 제거
        String trimmed = cat.trim();

        // 공백만 들어온 경우는 "카테고리 없음"으로 간주
        if (trimmed.isEmpty()) {
            cri.setCategory(null);
            return;
        }

        String up = trimmed.toUpperCase();

        if (!ITEM_CATEGORIES.contains(up)) {
            // 원래 값도 같이 찍어주면 디버깅할 때 좋음
            throw new IllegalArgumentException("Invalid category: [" + cat + "]");
        }

        // 정제된 값으로 세팅
        cri.setCategory(up);
    }


    @Override
    public List<InvenItemViewDTO> getInventoryPage(Criteria cri) {
        normalizeAndValidate(cri);
        return inventoryMapper.selectInventoryPage(cri);
    }

    @Override
    public int getInventoryTotal(Criteria cri) {
        normalizeAndValidate(cri);
        return inventoryMapper.selectInventoryTotal(cri);
    }

    // InboundDetailDTO는 그대로 사용 (sectionIndex: String)
    @Override
    @Transactional
    public Long applyInbound(InboundDetailDTO d) {
        if (d.getInboundIndex() == null) {
            throw new IllegalArgumentException("inboundIndex가 필요합니다.");
        }

        final Long inboundIndex = d.getInboundIndex();

        // 1) inboundIndex 기반 파생 정보 조회
        Long itemIndex       = inventoryMapper.selectItemIndexByInbound(inboundIndex);
        Long warehouseIndex  = inventoryMapper.selectWarehouseByInbound(inboundIndex);
        Long sectionIndex  = inventoryMapper.selectSectionByInbound(inboundIndex); // 문자열

        if (itemIndex == null || warehouseIndex == null || sectionIndex == null) {
            throw new IllegalStateException("입고 상세에서 item/warehouse/section 정보를 찾을 수 없습니다.");
        }

        // 2) 재고 upsert(+)
        InvenDTO dto = new InvenDTO();
        dto.setItemIndex(itemIndex);
        dto.setWarehouseIndex(warehouseIndex);
        dto.setSectionIndex(sectionIndex);
        dto.setInvenQuantity(Math.toIntExact(d.getReceivedQuantity()));     // 누적 +=
        dto.setInboundDate(d.getCompleteDate() != null ? d.getCompleteDate() : LocalDateTime.now());
        dto.setDetailInbound(d.getDetailIndex()); // detail_index 그대로 저장 (nullable OK)

        inventoryMapper.upsertIncrease(dto);
        Long invenIndex = inventoryMapper.selectInvenIndex(dto);

        // 3) 실사 스냅샷
        inventoryMapper.insertInvenCountSnapshot(invenIndex);

        return invenIndex;
    }


    @Override
    @Transactional
    public Long applyOutbound(ShippingInstructionDetailDTO s) {
        // 출고 상세(or_index 기반)로 item/warehouse/section/qty 확보
        Long itemIndex      = s.getItem_index();
        Long warehouseIndex = s.getWarehouse_index();
        Long sectionIndex      = s.getSection_index();
        int  qty            = s.getOr_quantity();

        if (itemIndex == null || warehouseIndex == null || sectionIndex == null) {
            // 필요시 mapper로 or_index -> item/wh/section 조회하는 쿼리 제공 가능
            throw new IllegalStateException("출고 상세에서 item/warehouse/section 정보를 찾을 수 없습니다.");
        }

        InvenDTO dto = new InvenDTO();
        dto.setItemIndex(itemIndex);
        dto.setWarehouseIndex(warehouseIndex);
        dto.setSectionIndex(sectionIndex);
        dto.setInvenQuantity(qty);                         // -=
        dto.setShippingDate(LocalDateTime.now());
        dto.setDetailOutbound(s.getSi_index());                   // 추적용

        // 1) 차감 시 0 미만 방지
        int ok = inventoryMapper.decreaseIfEnough(dto);
        if (ok == 0) {
            throw new IllegalStateException("재고 부족으로 출고 반영 실패");
        }

        // 2) invenIndex 조회
        Long invenIndex = inventoryMapper.selectInvenIndex(dto);

        // 3) 정책상: 재고 → 실재고
        inventoryMapper.insertInvenCountSnapshot(invenIndex);

        return invenIndex;
    }

    @Override
    @Transactional
    public void snapshotToInvenCount(Long invenIndex) {
        inventoryMapper.insertInvenCountSnapshot(invenIndex);
    }

}
