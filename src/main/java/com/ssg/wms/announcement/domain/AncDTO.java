package com.ssg.wms.announcement.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor

public class AncDTO {
    private int request_index;
    private String r_title;
    private String r_content;
    private LocalDateTime r_createAt;
    private LocalDateTime r_updateAt;
    private String r_status;
    private String r_type;
    private String r_response;
    private int notice_index;
    private String n_title;
    private String n_content;
    private LocalDateTime n_createAt;
    private LocalDateTime n_updateAt;
    private int n_priority;

}
