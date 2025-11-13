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

    private static void normalizeAndValidate(Criteria cri){
        if (cri.getCategory() != null && !cri.getCategory().isBlank()) {
            String up = cri.getCategory().toUpperCase();
            if (!ITEM_CATEGORIES.contains(up)) {
                throw new IllegalArgumentException("Invalid category: " + cri.getCategory());
            }
            cri.setCategory(up);
        }
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

    @Override
    @Transactional
    public Long applyInbound(InboundDetailDTO d) {
        // 1) 입고 상세로부터 item/warehouse/section/qty 조회(필요시 조인으로 보강)
        // 여기서는 Shipping/Inbound DTO에 이미 값이 들어오는 것으로 가정:
        Long itemIndex      = d.getInboundIndex() != null ? inventoryMapper.selectItemIndexByInbound(d.getInboundIndex()) : null;
        Long warehouseIndex = inventoryMapper.selectWarehouseByRequest(d.getInboundIndex());
        Long sectionIndex      = inventoryMapper.selectSectionByRequest(d.getInboundIndex());

        if (itemIndex == null || warehouseIndex == null || sectionIndex == null) {
            throw new IllegalStateException("입고 상세에서 item/warehouse/section 정보를 찾을 수 없습니다.");
        }

        InvenDTO dto = new InvenDTO();
        dto.setItemIndex(itemIndex);
        dto.setWarehouseIndex(warehouseIndex);
        dto.setSectionIndex(sectionIndex);
        dto.setInvenQuantity(Math.toIntExact(d.getReceivedQuantity()));   // +=
        dto.setInboundDate(d.getCompleteDate() != null ? d.getCompleteDate() : LocalDateTime.now());
        dto.setDetailInbound(d.getDetailIndex() != null ? d.getDetailIndex().longValue() : null);

        // 2) 업서트: 없으면 INSERT, 있으면 누적
        inventoryMapper.upsertIncrease(dto);
        Long invenIndex = inventoryMapper.selectInvenIndex(dto);

        // 3) 정책상: 재고 → 실재고 순서
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
