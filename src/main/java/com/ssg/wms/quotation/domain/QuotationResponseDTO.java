package com.ssg.wms.quotation.domain;

import com.ssg.wms.global.Enum.EnumStatus;

import java.time.LocalDateTime;

public class QuotationResponseDTO {
    private Long qresponse_index;
    private Long qrequest_index;
    private Long admin_index;
    private String qresponse_detail;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;
    private EnumStatus status;
}
