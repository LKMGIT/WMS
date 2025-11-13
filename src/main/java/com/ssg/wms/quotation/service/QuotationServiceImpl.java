package com.ssg.wms.quotation.service;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.quotation.domain.*;
import com.ssg.wms.quotation.mappers.QuotationMapper;
import lombok.RequiredArgsConstructor;
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
    public boolean registerQuotationRequest(QuotationRequestDTO quotationRequestDTO) {
        return quotationMapper.insertQuotationRequest(quotationRequestDTO) > 0;
    }

    @Override
    @Transactional
    public boolean modifyQuotationRequest(QuotationRequestDTO quotationRequestDTO) {
        boolean result = quotationMapper.updateQuotationRequest(quotationRequestDTO) > 0;
        if(result) {
            QuotationRequestDTO request = quotationMapper.selectQuotationRequest(quotationRequestDTO.getQrequest_index());
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

    @Override
    @Transactional
    public QuotationRequestDTO getQuotationRequestById(Long qrequest_index) {
        return quotationMapper.selectQuotationRequest(qrequest_index);
    }

    // 견적 상세 조회 (요청 + 답변 DTO 조합)
    @Override
    @Transactional
    public QuotationDetailDTO getQuotationRequestDetailById(QuotationSearchDTO quotationSearchDTO, Long qrequest_index) {
        // 1. 요청 기본 정보 조회
        QuotationRequestDTO request = quotationMapper.selectQuotationRequest(qrequest_index);
        if (request == null) return null;

        // 2. 답변 정보 조회 (PENDING/ANSWERED 무관하게 시도. response는 null일 수 있음)
        QuotationResponseDTO response = quotationMapper.selectQuotationResponse(qrequest_index);

        // 3. 이전/다음 글 인덱스 조회
        Long previous = quotationMapper.getPreviousQuotationPostIndex(quotationSearchDTO, qrequest_index);
        Long next = quotationMapper.getNextQuotationPostIndex(quotationSearchDTO, qrequest_index);

        // 4. DTO 빌더 통합: NullPointerException 방지 로직 적용

        QuotationDetailDTO.QuotationDetailDTOBuilder builder = QuotationDetailDTO.builder()
                // Request 필수 필드는 항상 존재함
                .qrequest_index(request.getQrequest_index())
                .user_index(request.getUser_index())
                .qrequest_name(request.getQrequest_name()) // qrequest_name (작성자 이름 필드)
                .qrequest_email(request.getQrequest_email())
                .qrequest_phone(request.getQrequest_phone())
                .qrequest_detail(request.getQrequest_detail())
                .qrequest_status(request.getQrequest_status())
                .updated_at(request.getUpdated_at()) // DDL에 따라 updated_at 사용
                .previousPostIndex(previous)
                .nextPostIndex(next);

        // ▼▼▼ Null 체크 후 답변 필드만 추가 (response가 null일 때 안전하게 건너뛰기) ▼▼▼
        if (response != null) {
            builder
                    .qresponse_index(response.getQresponse_index())
                    .qresponse_detail(response.getQresponse_detail())
                    .admin_index(response.getAdmin_index())
                    .responded_at(response.getUpdated_at());
        }
        // ▲▲▲ Null 체크 끝 ▲▲▲

        return builder.build();
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

    @Override
    @Transactional
    public QuotationCommentDTO getQuotationCommentById(Long qcomment_index) {
        return quotationMapper.selectQuotationComment(qcomment_index);
    }

    @Override
    @Transactional
    public QuotationResponseDTO getQuotationResponse (Long qresponse_index) {
        return quotationMapper.selectQuotationResponseByIndex(qresponse_index);
    }
}
