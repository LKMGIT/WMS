package com.ssg.wms.announcement.service;

import com.ssg.wms.announcement.domain.NoticeDTO;
import com.ssg.wms.announcement.mappers.NoticeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeMapper noticeMapper;

    @Override
    public Integer registerNotice(NoticeDTO noticeDTO, Long adminId) {
        // 관리자 ID 설정
        noticeDTO.setAdminIndex(adminId);
        noticeMapper.insertNotice(noticeDTO);
        return noticeDTO.getNoticeIndex();
    }

    @Override
    public List<NoticeDTO> getNotices(String keyword) {
        return noticeMapper.selectNotices(keyword);
    }

    @Override
    public NoticeDTO getNoticeDetail(Integer noticeIndex) {
        return noticeMapper.selectNotice(noticeIndex);
    }

    @Override
    public boolean updateNotice(NoticeDTO noticeDTO, Long adminId) {
        // 공지사항 존재 여부 확인
        NoticeDTO existing = noticeMapper.selectNotice(noticeDTO.getNoticeIndex());
        if (existing == null) {
            return false;
        }
        noticeDTO.setAdminIndex(adminId);
        return noticeMapper.updateNotice(noticeDTO) > 0;
    }

    @Override
    public boolean deleteNotice(Integer noticeIndex, Long adminId) {
        // 공지사항 존재 여부 확인
        NoticeDTO existing = noticeMapper.selectNotice(noticeIndex);
        if (existing == null) {
            return false;
        }

        return noticeMapper.deleteNotice(noticeIndex) > 0;
    }
}