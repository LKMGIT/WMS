package com.ssg.wms.outbound.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
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
public class DispatchDTO {
    private Long dispatch_index;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy. MM. dd. a hh:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime dispatch_date;
    private String start_point;
    private String end_point;
    private Long vehicle_index;
    private Long or_index;
    private EnumStatus status;
}
