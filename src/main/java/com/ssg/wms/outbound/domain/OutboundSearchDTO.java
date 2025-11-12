package com.ssg.wms.outbound.domain;

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
public class OutboundSearchDTO {
    private int page;
    private int amount;

    private LocalDate start_date;
    private LocalDate end_date;
    private EnumStatus dispatch_status;
    private EnumStatus approval_status;
    private String sort;
    // keyword 2개가 타입과 keyword로 바뀜
    private String type;
    private String keyword;

    // ▼ (추가) sort 필드의 getter
    // 컨트롤러에서 값을 따로 세팅 안 하면(null이면) 기본값 "DESC" 반환
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
