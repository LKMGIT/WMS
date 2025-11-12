package com.ssg.wms.announcement.service;

import com.ssg.wms.announcement.domain.NoticeDTO;

import java.util.List;


public interface NoticeService {

    /** 공지사항 등록 (관리자)  */
    Integer registerNotice(NoticeDTO noticeDTO, Long adminId);

    /** 공지사항 목록 조회 */
    List<NoticeDTO> getNotices(String keyword);

    /** 공지사항 상세 조회 */
    NoticeDTO getNoticeDetail(Integer noticeIndex);

    /** 공지사항 수정 (관리자) */
    boolean updateNotice(NoticeDTO noticeDTO, Long adminId);

    /** 공지사항 삭제 (관리자) */
    boolean deleteNotice(Integer noticeIndex, Long adminId);
}