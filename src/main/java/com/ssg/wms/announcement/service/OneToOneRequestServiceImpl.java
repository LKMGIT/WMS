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

        // 관리자는 답변 여부와 상관없이 삭제 가능
        return oneToOneRequestMapper.deleteRequest(requestIndex) > 0;
    }
}