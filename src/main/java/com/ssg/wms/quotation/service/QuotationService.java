package com.ssg.wms.quotation.service;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.quotation.domain.*;

import java.util.List;

public interface QuotationService {

    /**
     * 견적 요청 리스트 (페이징 + 검색)
     */
    List<QuotationRequestDTO> getQuotationRequestList(Criteria criteria, QuotationSearchDTO quotationSearchDTO);

    /**
     * 견적 요청 검색된 총 개수
     */
    int getQuotationRequestTotalCount(QuotationSearchDTO quotationSearchDTO);

    /**
     * 견적 요청 등록
     */
    boolean registerQuotationRequest(QuotationRequestDTO requestDTO);

    /**
     * 견적 요청 수정
     * (수정 시 답변이 달려있었다면, 답변을 삭제하고 상태를 PENDING으로 변경)
     */
    boolean modifyQuotationRequest(QuotationRequestDTO requestDTO);

    /**
     * 견적 요청 삭제
     * (삭제 시 답변이 달려있었다면, 답변도 함께 삭제)
     */
    boolean removeQuotationRequest(Long qrequest_index);

    /**
     * 견적 요청 단건 조회 (CUD 재조회용)
     * (QuotationRequestDTO 반환)
     */
    QuotationRequestDTO getQuotationRequestById(Long qrequest_index);

    /**
     * 견적 상세 조회 (요청 + 답변 DTO 조합 및 이전/다음 글 ID 포함)
     * (QuotationDetailDTO 반환)
     * (참고: ServiceImpl에 'next' 조회 버그가 있을 수 있습니다. getPreviousQuotationPostIndex를 두 번 호출 [cite: lkmgit/wms/WMS-dev-JJW/src/main/java/com/ssg/wms/quotation/service/QuotationServiceImpl.java])
     */
    QuotationDetailDTO getQuotationRequestDetailById(QuotationSearchDTO quotationSearchDTO, Long qrequest_index);

    /**
     * 견적 답변 등록
     * (등록 시 견적 요청 상태를 ANSWERED로 변경)
     */
    boolean registerQuotationResponse(QuotationResponseDTO quotationResponseDTO);

    /**
     * 견적 답변 조회 (qrequest_index 기준)
     */
    QuotationResponseDTO getQuotationResponseById(Long qrequest_index);

    /**
     * 견적 답변 수정
     */
    boolean modifyQuotationResponse(QuotationResponseDTO quotationResponseDTO);

    /**
     * 견적 답변 삭제
     */
    boolean removeQuotationResponse(Long qresponse_index);

    /**
     * 견적 댓글 리스트 (페이징)
     */
    List<QuotationCommentDTO> getQuotationCommentList(Criteria criteria, Long qrequest_index);

    /**
     * 견적 댓글 총 개수
     */
    int getQuotationCommentTotalCount(Long qrequest_index);

    /**
     * 견적 댓글 등록
     */
    boolean registerQuotationComment(QuotationCommentDTO quotationCommentDTO);

    /**
     * 견적 댓글 수정
     */
    boolean modifyQuotationComment(QuotationCommentDTO quotationCommentDTO);

    /**
     * 견적 댓글 삭제
     */
    boolean removeQuotationComment(Long qcomment_index);

    QuotationCommentDTO getQuotationCommentById(Long qcomment_index);

    QuotationResponseDTO getQuotationResponse ( Long qresponse_index);
}
