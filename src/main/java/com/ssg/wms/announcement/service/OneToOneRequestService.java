package com.ssg.wms.announcement.service;


import com.ssg.wms.announcement.domain.OneToOneRequestDTO;
import java.util.List;

public interface OneToOneRequestService {

    // 관리자 전용 메서드
    /** 관리자용 1:1 문의 목록 조회 */
    List<OneToOneRequestDTO> getAdminRequests(String keyword, String status);

    /** 1:1 문의 답변 등록/수정 (관리자) */
    boolean replyToRequest(Integer requestIndex, String response, Long adminId);

    /** 관리자의 1:1 문의 삭제 */
    boolean deleteAdminRequest(Integer requestIndex, Long adminId);

    /** [추가] 1:1 문의 상세 조회 (관리자) */
    OneToOneRequestDTO getAdminRequest(Integer requestIndex);
}