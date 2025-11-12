package com.ssg.wms.inventory.mappers;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.inventory.domain.InvenDTO;
import com.ssg.wms.inventory.domain.InvenItemViewDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InvenMapper {

    List<InvenItemViewDTO> selectInventoryPage(@Param("cri") Criteria cri);
    int selectInventoryTotal(@Param("cri") Criteria cri);

    // 입고: 업서트(+)
    int upsertIncrease(InvenDTO dto);

    // 출고: 가능할 때만 차감
    int decreaseIfEnough(InvenDTO dto);

    // 행 식별
    Long selectInvenIndex(InvenDTO key);

    // 실재고 스냅샷
    int insertInvenCountSnapshot(@Param("invenIndex") Long invenIndex);


    // 보조 조회(서비스에서 호출)
    Long selectItemIndexByInbound(@Param("inboundIndex") Long inboundIndex);
    Long selectWarehouseByRequest(@Param("requestIndex") Long requestIndex);
    Long selectSectionByRequest(@Param("requestIndex") Long requestIndex);

}
