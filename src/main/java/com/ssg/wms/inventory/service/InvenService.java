package com.ssg.wms.inventory.service;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.inbound.domain.InboundDetailDTO;
import com.ssg.wms.inventory.domain.InvenItemViewDTO;
import com.ssg.wms.outbound.domain.ShippingInstructionDetailDTO;

import java.util.List;

public interface InvenService {

    List<InvenItemViewDTO> getInventoryPage(Criteria cri);
    int getInventoryTotal(Criteria cri);
    default PageDTO buildPage(Criteria cri, int total){ return new PageDTO(cri, total); }


    /** 입고 상세 확정 시: 수량 += receivedQuantity, 행이 없으면 생성 */
    Long applyInbound(InboundDetailDTO inboundDetail);

    /** 출고 지시 상세 확정 시: 수량 -= or_quantity (음수 불가) */
    Long applyOutbound(ShippingInstructionDetailDTO shippingDetail);

    /** (선택) 재고 스냅샷 실재고 테이블 반영 */
    void snapshotToInvenCount(Long invenIndex);
}
