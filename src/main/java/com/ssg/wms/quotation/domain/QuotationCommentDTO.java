package com.ssg.wms.quotation.domain;

import com.ssg.wms.global.Enum.EnumStatus;

import java.time.LocalDateTime;

public class QuotationCommentDTO {
    private Long qcomment_index;
    private Long qrequest_index;
    private String qcomment_detail;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;
    private EnumStatus status;
    private EnumStatus writer_type;
    private Long user_index;
    private Long admin_index;
}
