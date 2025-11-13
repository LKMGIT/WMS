package com.ssg.wms.announcement.mappers;


import com.ssg.wms.announcement.domain.NoticeDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;


@Mapper
public interface NoticeMapper {

    /** 공지사항 등록 */
    int insertNotice(NoticeDTO noticeDTO);

    /** 공지사항 목록 조회 */
    List<NoticeDTO> selectNotices(@Param("keyword") String keyword);

    /** 공지사항 상세 조회 */
    NoticeDTO selectNotice(@Param("notice_index") Integer noticeIndex);

    /** 공지사항 수정 */
    int updateNotice(NoticeDTO noticeDTO);

    /** 공지사항 삭제 */
    int deleteNotice(@Param("notice_index") Integer noticeIndex);
}