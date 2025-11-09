package com.ssg.wms.quotation.service;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.dto.PageResponseDTO;
import com.ssg.wms.quotation.domain.*;
import com.ssg.wms.quotation.mappers.QuotationMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class QuotationServiceImpl implements QuotationService {

    private final QuotationMapper quotationMapper;

    // 견적 요청 리스트 (페이징 + 검색)
    @Override
    @Transactional
    public List<QuotationRequestDTO> getQuotationRequestList(Criteria criteria, QuotationSearchDTO quotationSearchDTO) {
        return quotationMapper.selectQuotationRequestList(criteria, quotationSearchDTO);
    }

    @Override
    @Transactional
    public int getQuotationRequestTotalCount( QuotationSearchDTO quotationSearchDTO ){
        return quotationMapper.selectQuotationRequestTotalCount(quotationSearchDTO);
    }

    // 견적 요청 등록
    @Override
    @Transactional
    public boolean registerQuotationRequest(QuotationRequestDTO requestDTO) {
        return quotationMapper.insertQuotationRequest(requestDTO) > 0;
    }

    @Override
    @Transactional
    public boolean modifyQuotationRequest(QuotationRequestDTO requestDTO) {
        boolean result = quotationMapper.updateQuotationRequest(requestDTO) > 0;
        if(result) {
            QuotationRequestDTO request = quotationMapper.selectQuotationRequest(requestDTO.getQrequest_index());
            if(request.getQrequest_status() == EnumStatus.ANSWERED) {
                request.setQrequest_status(EnumStatus.PENDING);
                QuotationResponseDTO response = quotationMapper.selectQuotationResponse(request.getQrequest_index());
                quotationMapper.deleteQuotationResponse(response.getQresponse_index());
            }
        }
        return result;
    }

    @Override
    @Transactional
    public boolean removeQuotationRequest(Long qrequest_index) {
        QuotationRequestDTO request = quotationMapper.selectQuotationRequest(qrequest_index);
        if(request.getQrequest_status() == EnumStatus.ANSWERED) {
            request.setQrequest_status(EnumStatus.PENDING);
            QuotationResponseDTO response = quotationMapper.selectQuotationResponse(request.getQrequest_index());
            quotationMapper.deleteQuotationResponse(response.getQresponse_index());
        }
        return quotationMapper.deleteQuotationRequest(qrequest_index) > 0;
    }

    // 견적 상세 조회 (요청 + 답변 DTO 조합)
    @Override
    @Transactional
    public QuotationDetailDTO getQuotationRequestById(Long qrequest_index) {
        // 건적 신청 단건 데이터 가져오기
        QuotationRequestDTO request = quotationMapper.selectQuotationRequest(qrequest_index);

        if(request.getQrequest_status() == EnumStatus.PENDING) {
            return QuotationDetailDTO.builder()
                    .qrequest_index(request.getQrequest_index())
                    .user_index(request.getUser_index())
                    .qrequest_name(request.getQrequest_name())
                    .qrequest_email(request.getQrequest_email())
                    .qrequest_phone(request.getQrequest_phone())
                    .qrequest_detail(request.getQrequest_detail())
                    .qrequest_status(request.getQrequest_status())
                    .updated_at(request.getUpdated_at())
                    .build();
        } else {
            // 견적 답변 조회
            QuotationResponseDTO response = quotationMapper.selectQuotationResponse(qrequest_index);


            // 3. QuotationDetailDTO로 조합
            return QuotationDetailDTO.builder()
                    .qrequest_index(request.getQrequest_index())
                    .user_index(request.getUser_index())
                    .qrequest_name(request.getQrequest_name())
                    .qrequest_email(request.getQrequest_email())
                    .qrequest_phone(request.getQrequest_phone())
                    .qrequest_detail(request.getQrequest_detail())
                    .qrequest_status(request.getQrequest_status())
                    .updated_at(request.getUpdated_at())
                    .qresponse_index(response.getQresponse_index())
                    .qresponse_detail(response.getQresponse_detail())
                    .admin_index(response.getAdmin_index())
                    .responded_at(response.getUpdated_at())
                    .build();
        }
    }

    // 견적 답변 등록
    @Override
    @Transactional
    public boolean registerQuotationResponse(QuotationResponseDTO quotationResponseDTO) {
        // 답변 등록
        boolean result = quotationMapper.insertQuotationResponse(quotationResponseDTO) > 0;

        if(result) {
            QuotationRequestDTO request = quotationMapper.selectQuotationRequest(quotationResponseDTO.getQrequest_index());
            request.setQrequest_status(EnumStatus.ANSWERED);
            quotationMapper.updateQuotationRequest(request);
        }
        return result;
    }

    @Override
    @Transactional
    public QuotationResponseDTO getQuotationResponseById(Long qrequest_index) {
        return quotationMapper.selectQuotationResponse(qrequest_index);
    }

    @Override
    @Transactional
    public boolean modifyQuotationResponse(QuotationResponseDTO quotationResponseDTO) {
        return quotationMapper.updateQuotationResponse(quotationResponseDTO) > 0;
    }

    @Override
    @Transactional
    public boolean removeQuotationResponse(Long qresponse_index) {
        return quotationMapper.deleteQuotationResponse(qresponse_index) > 0;
    }


    // 견적 댓글 리스트 (페이징)
    @Override
    @Transactional
    public List<QuotationCommentDTO> getQuotationCommentList(Criteria criteria, Long qrequest_index) {
        return quotationMapper.selectQuotationCommentList(criteria, qrequest_index);
    }

    @Override
    @Transactional
    public int getQuotationCommentTotalCount(Long qrequest_index){
        return quotationMapper.selectQuotationCommentTotalCount(qrequest_index);
    }

    // 견적 댓글 등록
    @Override
    @Transactional
    public boolean registerQuotationComment(QuotationCommentDTO quotationCommentDTO) {
        return quotationMapper.insertQuotationComment(quotationCommentDTO) > 0;
    }

    @Override
    @Transactional
    public boolean modifyQuotationComment(QuotationCommentDTO quotationCommentDTO) {
        return quotationMapper.updateQuotationComment(quotationCommentDTO) > 0;
    }

    @Override
    @Transactional
    public boolean removeQuotationComment(Long qcomment_index) {
        return quotationMapper.deleteQuotationComment(qcomment_index) > 0;
    }
}
