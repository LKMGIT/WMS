package com.ssg.wms.admin.domain;

import lombok.Data;

@Data

public class AdminDTO {
    private Long adminIndex;
    private String adminName;
    private String adminPw;
    private String adminId;
    private String adminRole;
    private String adminPhone;
    private java.time.LocalDateTime adminCreatedAt;
    private java.time.LocalDateTime adminUpdateAt;
    private String adminStatus;
}
