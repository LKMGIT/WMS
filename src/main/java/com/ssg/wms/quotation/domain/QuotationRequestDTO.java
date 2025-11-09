package com.ssg.wms.quotation.domain;

import com.ssg.wms.global.Enum.EnumStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class QuotationRequestDTO {
    private Long qrequest_index;
    private Long user_index;
    private String qrequest_name;
    private String qrequest_email;
    private String qrequest_phone;
    private String qrequest_company;
    private String qrequest_detail;
    private EnumStatus qrequest_status;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;
    private EnumStatus status;
}
