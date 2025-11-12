package com.ssg.wms.warehouse.mappers;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.warehouse.domain.WarehouseDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface WarehouseMapper {
    List<WarehouseDTO> getList(Criteria criteria);
    int getTotal(Criteria criteria);
    int insertWarehouse(WarehouseDTO warehouseDTO); // 창고 등록
    WarehouseDTO findWarehouse(Long wIndex); // 창고 하나 조회
//    List<WarehouseDTO> findAllWarehouses(WarehouseSearchDTO warehouseSearchDTO); // 창고 조건별 조회
    int updateWarehouse(WarehouseDTO warehouseDTO); // 창고 수정
    int deactiveWarehouse(Long wIndex); // 창고 폐쇄(논리적 폐쇄)
    int getNextCode();
}
