package com.ssg.wms.warehouse.service;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.warehouse.domain.*;
import com.ssg.wms.warehouse.mappers.SectionMapper;
import com.ssg.wms.warehouse.mappers.WarehouseMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class WarehouseServiceImpl implements WarehouseService {
    private final WarehouseMapper warehouseMapper;
    private final SectionMapper sectionMapper;

    @Override
    public List<WarehouseDTO> getList(Criteria cri) {
        return warehouseMapper.getList(cri);
    }

    @Override
    public int getTotal(Criteria cri) {
        return warehouseMapper.getTotal(cri);
    }

    @Transactional
    @Override
    public boolean registerWarehouse(WarehouseSaveDTO warehouseSaveDTO) {
        String code = "WH-" + UUID.randomUUID().toString().substring(0,4);
        WarehouseDTO warehouseDTO = WarehouseDTO.builder()
                .wCode(code)
                .wName(warehouseSaveDTO.getWName())
                .wSize(warehouseSaveDTO.getWSize())
                .wLocation(warehouseSaveDTO.getWLocation())
                .wAddress(warehouseSaveDTO.getWAddress())
                .wZipcode(warehouseSaveDTO.getWZipcode())
                .build();

        warehouseMapper.insertWarehouse(warehouseDTO);

        Long warehouseIndex = warehouseDTO.getWIndex();

        int warehouseSize = warehouseSaveDTO.getWSize();
        int sectionCapacity = (int) (warehouseSize * 0.3);

        for (int i = 1; i <= 3; i++) {
            SectionDTO section = SectionDTO.builder()
                    .sCode("S-" + warehouseIndex + "-" + i)
                    .sName("구역 " + i)
                    .sCapacity(sectionCapacity)
                    .wIndex(warehouseIndex)
                    .build();

            sectionMapper.insertSection(section);
        }

        return true;
    }

    @Transactional
    @Override
    public boolean modifyWarehouse(WarehouseUpdateDTO warehouseUpdateDTO) {
        WarehouseDTO exist = warehouseMapper.findWarehouse(warehouseUpdateDTO.getWIndex());
        if (exist == null) return false;

        WarehouseDTO dto = WarehouseDTO.builder()
                .wIndex(warehouseUpdateDTO.getWIndex())
                .wName(warehouseUpdateDTO.getWName())
                .wLocation(warehouseUpdateDTO.getWLocation())
                .wAddress(warehouseUpdateDTO.getWAddress())
                .wZipcode(warehouseUpdateDTO.getWZipcode())
                .wStatus(warehouseUpdateDTO.getWStatus())
                .build();

        int result = warehouseMapper.updateWarehouse(dto);

        return result == 1;
    }

    @Transactional
    @Override
    public boolean removeWarehouse(Long wIndex) {
        WarehouseDTO exist = warehouseMapper.findWarehouse(wIndex);
        if (exist == null) return false;
        int result = warehouseMapper.deactiveWarehouse(wIndex);
        return result == 1;
    }

    @Override
    public WarehouseDTO getWarehouse(Long wIndex) {
        WarehouseDTO warehouseDTO = warehouseMapper.findWarehouse(wIndex);
        if (warehouseDTO == null) {
            throw new IllegalArgumentException("존재하지 않는 창고입니다.");
        }
       return warehouseDTO;
    }

//    @Override
//    public List<WarehouseDTO> getAllWarehouses(WarehouseSearchDTO warehouseSearchDTO) {
//        List<WarehouseDTO> dtoList = warehouseMapper.findAllWarehouses(warehouseSearchDTO);
//        if (dtoList == null || dtoList.isEmpty()) {
//            throw new IllegalArgumentException("조회 가능한 창고가 없습니다.");
//        }
//        return dtoList;
//    }
}
