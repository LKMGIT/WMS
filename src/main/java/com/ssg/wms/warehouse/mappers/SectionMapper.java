package com.ssg.wms.warehouse.mappers;

import com.ssg.wms.warehouse.domain.SectionDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SectionMapper {
    int insertSection(SectionDTO sectionDTO);
}
