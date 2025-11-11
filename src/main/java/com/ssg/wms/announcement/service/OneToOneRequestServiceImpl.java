package com.ssg.wms.announcement.service;

import com.ssg.wms.announcement.domain.OneToOneRequestDTO;
import com.ssg.wms.announcement.mappers.OneToOneRequestMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class OneToOneRequestServiceImpl implements OneToOneRequestService {

    @Autowired
    private OneToOneRequestMapper oneToOneRequestMapper;

    @Override
    public Integer registerRequest(OneToOneRequestDTO requestDTO, Long userId) {
        requestDTO.setUserIndex(userId);
        requestDTO.setRStatus("PENDING");
        oneToOneRequestMapper.insertRequest(requestDTO);
        return requestDTO.getRequestIndex();
    }

    @Override
    public List<OneToOneRequestDTO> getMyRequests(Long userId, String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("keyword", keyword);
        return oneToOneRequestMapper.selectMyRequests(params);
    }

    @Override
    public OneToOneRequestDTO getRequestDetail(Integer requestIndex, Long userId) {
        OneToOneRequestDTO request = oneToOneRequestMapper.selectRequest(requestIndex);

        // 본인의 문의글인지 확인
        if (request != null && !request.getUserIndex().equals(userId)) {
            return null; // 권한 없음
        }

        return request;
    }

    @Override
    public boolean updateRequest(OneToOneRequestDTO requestDTO, Long userId) {
        OneToOneRequestDTO existing = oneToOneRequestMapper.selectRequest(requestDTO.getRequestIndex());
        if (existing == null || !existing.getUserIndex().equals(userId)) {
            return false;
        }

        // 이미 답변된 문의글은 수정 불가
        if ("ANSWERED".equals(existing.getRStatus())) {
            return false;
        }

        return oneToOneRequestMapper.updateRequest(requestDTO) > 0;
    }

    @Override
    public boolean deleteRequest(Integer requestIndex, Long userId) {
        OneToOneRequestDTO existing = oneToOneRequestMapper.selectRequest(requestIndex);
        if (existing == null || !existing.getUserIndex().equals(userId)) {
            return false;
        }

        // 답변 전에만 삭제 가능
        if ("ANSWERED".equals(existing.getRStatus())) {
            return false;
        }

        return oneToOneRequestMapper.deleteRequest(requestIndex) > 0;
    }

    // 관리자 전용 메서드
    @Override
    public List<OneToOneRequestDTO> getAdminRequests(String keyword, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("status", status);
        return oneToOneRequestMapper.selectRequests(params);
    }

    @Override
    public boolean replyToRequest(Integer requestIndex, String response, Long adminId) {
        OneToOneRequestDTO existing = oneToOneRequestMapper.selectRequest(requestIndex);
        if (existing == null) {
            return false;
        }

        OneToOneRequestDTO requestDTO = new OneToOneRequestDTO();
        requestDTO.setRequestIndex(requestIndex);
        requestDTO.setRResponse(response);
        requestDTO.setAdminIndex(adminId);

        return oneToOneRequestMapper.updateAnswer(requestDTO) > 0;
    }

    @Override
    public boolean deleteAdminRequest(Integer requestIndex, Long adminId) {
        OneToOneRequestDTO existing = oneToOneRequestMapper.selectRequest(requestIndex);
        if (existing == null) {
            return false;
        }

        return oneToOneRequestMapper.deleteRequest(requestIndex) > 0;
    }
}
