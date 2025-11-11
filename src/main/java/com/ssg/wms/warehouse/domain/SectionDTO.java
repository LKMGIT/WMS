package com.ssg.wms.warehouse.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SectionDTO {
    private Long sIndex;
    private String sCode;
    private String sName;
    private int sCapacity;
    private Long wIndex;
}
