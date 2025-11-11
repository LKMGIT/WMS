package com.ssg.wms.announcement.mappers;

import com.ssg.wms.announcement.domain.OneToOneRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface OneToOneRequestMapper {

    /** 1:1 문의 등록 */
    int insertRequest(OneToOneRequestDTO requestDTO);

    /** 사용자 본인의 1:1 문의 목록 조회 */
    List<OneToOneRequestDTO> selectMyRequests(Map<String, Object> params);

    /** 관리자용 1:1 문의 목록 조회 */
    List<OneToOneRequestDTO> selectRequests(Map<String, Object> params);

    /** 1:1 문의 상세 조회 */
    OneToOneRequestDTO selectRequest(@Param("request_index") Integer requestIndex);

    /** 1:1 문의 수정 (답변 전에만) */
    int updateRequest(OneToOneRequestDTO requestDTO);

    /** 1:1 문의 답변 등록/수정 (관리자) */
    int updateAnswer(OneToOneRequestDTO requestDTO);

    /** 1:1 문의 삭제 */
    int deleteRequest(@Param("request_index") Integer requestIndex);
}
