package com.ssg.wms.quotation.domain;

import com.ssg.wms.global.Enum.EnumStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuotationSearchDTO {
    private LocalDate start_date;
    private LocalDate end_date;
    private EnumStatus qrequest_status;
    private String sort;
    private String type;
    private String keyword;
}
