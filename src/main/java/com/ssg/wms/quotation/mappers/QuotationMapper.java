package com.ssg.wms.quotation.mappers;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.outbound.domain.OutboundSearchDTO;
import com.ssg.wms.quotation.domain.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface QuotationMapper {
    int insertQuotationRequest (QuotationRequestDTO quotationRequestDTO );
    int updateQuotationRequest ( QuotationRequestDTO quotationRequestDTO );
    int deleteQuotationRequest ( Long qrequest_index );
    QuotationRequestDTO selectQuotationRequest ( Long qrequest_index );
    List<QuotationRequestDTO> selectQuotationRequestList (@Param("cri") Criteria criteria, @Param("search") QuotationSearchDTO quotationSearchDTO );
    int selectQuotationRequestTotalCount( @Param("search") QuotationSearchDTO quotationSearchDTO );
    QuotationResponseDTO selectQuotationResponse ( Long qrequest_index );
    int	insertQuotationResponse ( QuotationResponseDTO quotationResponseDTO );
    int	updateQuotationResponse ( QuotationResponseDTO quotationResponseDTO );
    int	deleteQuotationResponse ( Long qresponse_index );
    int	insertQuotationComment ( QuotationCommentDTO quotationCommentDTO );
    int	updateQuotationComment ( QuotationCommentDTO quotationCommentDTO );
    int deleteQuotationComment ( Long qcomment_index );
    List<QuotationCommentDTO> selectQuotationCommentList (@Param("cri") Criteria criteria, @Param("qrequest_index") Long qrequest_index );
    int selectQuotationCommentTotalCount( Long qrequest_index );

    Long getPreviousQuotationPostIndex(
            @Param("search") QuotationSearchDTO searchDTO, // OutboundSearchDTO 대신 QuotationSearchDTO 사용
            @Param("current_index") Long current_index
    );
    Long getNextQuotationPostIndex(
            @Param("search") QuotationSearchDTO searchDTO, // OutboundSearchDTO 대신 QuotationSearchDTO 사용
            @Param("current_index") Long current_index
    );

    QuotationCommentDTO selectQuotationComment(Long qcomment_index);
}
