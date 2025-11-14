package com.ssg.wms.warehouse.mappers;

import com.ssg.wms.warehouse.domain.SectionDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SectionMapper {
    int insertSection(SectionDTO sectionDTO);
    Integer calculateSectionRemain(@Param("sIndex") Long sIndex);
    List<SectionDTO> getSectionsByWarehouse(@Param("wIndex") Long wIndex);
}
