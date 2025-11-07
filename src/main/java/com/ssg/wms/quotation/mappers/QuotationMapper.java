package com.ssg.wms.quotation.mappers;

import com.ssg.wms.quotation.domain.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface QuotationMapper {
    public int insertQuotationRequest (QuotationRequestDTO quotationRequestDTO );
    public int updateQuotationRequest ( QuotationRequestDTO quotationRequestDTO );
    public int deleteQuotationRequest ( Long qrequest_index );
    public QuotationRequestDTO selectQuotationRequest ( QuotationRequestDTO quotationRequestDTO );
    public List<QuotationRequestDTO> selectQuotationRequestList ( @Param("search") QuotationSearchDTO quotationSearchDTO );
    public	QuotationResponseDTO selectQuotationResponse ( Long qrequest_index );
    public 	int	insertQuotationResponse ( QuotationResponseDTO quotationResponseDTO );
    public 	int	updateQuotationResponse ( QuotationResponseDTO quotationResponseDTO );
    public 	int	deleteQuotationResponse ( Long qresponse_index );
    public 	int	insertQuotationComment ( QuotationCommentDTO quotationCommentDTO );
    public 	int	updateQuotationComment ( QuotationCommentDTO quotationCommentDTO );
    public	int deleteQuotationComment ( Long qcomment_index );
    public List<QuotationCommentDTO> selectQuotationCommentList ( Long qrequest_index );
    public QuotationCommentDTO	selectQuotationComment ( Long qcomment_index );
}
