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

        // 중복 검사 (이름 or 주소)
        int duplicateCount = warehouseMapper.isDuplicate(
                warehouseSaveDTO.getWName(),
                warehouseSaveDTO.getWAddress()
        );

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("동일한 이름 또는 주소의 창고가 이미 존재합니다.");
        }

        // 창고 code 생성 -> 1부터시작
        int warehouseCodeNum =  warehouseMapper.getNextCode();
        WarehouseDTO warehouseDTO = WarehouseDTO.builder()
                .wCode(warehouseCodeNum)
                .wName(warehouseSaveDTO.getWName())
                .wSize(warehouseSaveDTO.getWSize())
                .wLocation(warehouseSaveDTO.getWLocation())
                .wAddress(warehouseSaveDTO.getWAddress())
                .wZipcode(warehouseSaveDTO.getWZipcode())
                .wStatus(EnumStatus.NORMAL)
                .build();

        warehouseMapper.insertWarehouse(warehouseDTO);

        Long warehouseIndex = warehouseDTO.getWIndex();
        int warehouseSize = warehouseSaveDTO.getWSize();

        int sectionCount = 0;
        if (warehouseSize >= 1 && warehouseSize <= 1000) {
            sectionCount = 3;
        } else if (warehouseSize <= 2000) {
            sectionCount = 4;
        } else if (warehouseSize <= 3000) {
            sectionCount = 5;
        } else {
            sectionCount = 6;
        }

        int sectionCapacity = warehouseSize / sectionCount;
        int remainder = warehouseSize % sectionCount; // 나머지 계산

        for (int i = 1; i <= sectionCount; i++) {
            int capacity = sectionCapacity;
            if (i == sectionCount) {
                capacity += remainder; // 마지막 구역에 나머지 더하기 ex) 1000->333, 333, 334
            }
            int sectionCode = warehouseCodeNum * 100 + i;

            SectionDTO section = SectionDTO.builder()
                    .sCode(sectionCode)
                    .sName("S-" + i)
                    .sCapacity(capacity)
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

        int used = warehouseMapper.getUsedCapacity(wIndex);
        int total = warehouseDTO.getWSize();

        double usageRate = total == 0 ? 0 : (double) used / total * 100;

        warehouseDTO.setUsageRate(Math.round(usageRate * 100) / 100.0);
       return warehouseDTO;
    }

    public Integer calculateSectionRemain(Long sIndex) {
        Integer remain = sectionMapper.calculateSectionRemain(sIndex);
        return remain == null ? 0 : remain;
    }

        public boolean canInbound(Long sIndex, int itemVolume, int quantity) {

        int required = itemVolume * quantity;
        int remain = calculateSectionRemain(sIndex);

        return remain >= required;
    }

}
