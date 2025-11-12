package com.ssg.wms.inventory.service;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.inventory.domain.InvenCountDTO;

import java.util.List;

public interface InvenCountService {

    // 조회
    List<InvenCountDTO> getPage(Criteria cri);
    int getTotal(Criteria cri);
    default PageDTO buildPage(Criteria cri, int total){ return new PageDTO(cri, total); }

    // 저장/수정/삭제
    Long create(InvenCountDTO dto);
    boolean update(InvenCountDTO dto);
    boolean delete(Long countIndex);
}
