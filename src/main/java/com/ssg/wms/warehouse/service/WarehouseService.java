package com.ssg.wms.warehouse.service;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.warehouse.domain.WarehouseDTO;
import com.ssg.wms.warehouse.domain.WarehouseSaveDTO;
import com.ssg.wms.warehouse.domain.WarehouseUpdateDTO;

import java.util.List;

public interface WarehouseService {
    List<WarehouseDTO> getList(Criteria cri);
    int getTotal(Criteria cri);
    boolean registerWarehouse(WarehouseSaveDTO warehouseSaveDTO);
    WarehouseDTO getWarehouse(Long wIndex);
    boolean modifyWarehouse(WarehouseUpdateDTO warehouseUpdateDTO);
    boolean removeWarehouse(Long wIndex);
    boolean canInbound(Long sectionId, int itemVolume, int quantity);
    Integer calculateSectionRemain(Long sectionId);
}
