package com.ssg.wms.warehouse.mappers;

import com.ssg.wms.warehouse.domain.SectionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SectionMapper {
    int insertSection(SectionDTO sectionDTO);
    int calculateSectionRemain(@Param("sectionId") Long sectionId);
    List<SectionDTO> getSectionsByWarehouse(@Param("warehouseIndex") Long warehouseIndex);
}
