package com.ssg.wms.quotation.domain;

import com.ssg.wms.global.Enum.EnumStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;


@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QuotationDetailDTO {
    private Long qrequest_index;
    private Long user_index;
    private String qrequest_name;
    private String qrequest_email;
    private String qrequest_detail;
    private String qrequest_phone;
    private EnumStatus qrequest_status;
    private LocalDateTime updated_at;
    private Long qresponse_index;
    private Long admin_index;
    private String qresponse_detail;
    private LocalDateTime responded_at;

    private Long previousPostIndex;
    private Long nextPostIndex;
}
