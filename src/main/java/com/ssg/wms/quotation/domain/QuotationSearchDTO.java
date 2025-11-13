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
    private int page;
    private int amount;

    private LocalDate start_date;
    private LocalDate end_date;
    private EnumStatus qrequest_status;
    private String sort;
    private String type;
    private String keyword;

    public String getSort() {
        if (this.sort == null || this.sort.isEmpty()) {
            return "DESC";
        }
        // "ASC"가 아니면 무조건 "DESC"로 처리 (SQL Injection 방지)
        if (this.sort.equalsIgnoreCase("ASC")) {
            return "ASC";
        }
        return "DESC";
    }

    // ▼ (추가) sort 필드의 setter
    public void setSort(String sort) {
        this.sort = sort;
    }
}
