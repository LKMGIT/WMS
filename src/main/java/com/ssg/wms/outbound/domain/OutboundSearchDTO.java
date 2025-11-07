package com.ssg.wms.outbound.domain;

import java.time.LocalDate;

public class OutboundSearchDTO {
    private LocalDate start_date;
    private LocalDate end_date;
    private String approval_status;
    private Long keyword;
    private String keyword2;
}
