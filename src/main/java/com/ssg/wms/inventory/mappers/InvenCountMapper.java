package com.ssg.wms.inventory.mappers;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.inventory.domain.InvenCountDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InvenCountMapper {
    // 조회
    List<InvenCountDTO> selectInvenCountPage(@Param("cri") Criteria cri);
    int selectInvenCountTotal(@Param("cri") Criteria cri);

    // 단건 조회(수정 전 확인용 선택)
    InvenCountDTO selectInvenCountById(@Param("countIndex") Long countIndex);

    // 저장(INSERT)
    int insertInvenCount(InvenCountDTO dto);

    // 수정(UPDATE by PK)
    int updateInvenCount(InvenCountDTO dto);

    // 삭제(DELETE by PK)
    int deleteInvenCount(@Param("countIndex") Long countIndex);
}
