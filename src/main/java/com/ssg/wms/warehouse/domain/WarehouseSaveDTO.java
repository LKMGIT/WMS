package com.ssg.wms.warehouse.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseSaveDTO {
    @JsonProperty("wName")
    private String wName;

    @JsonProperty("wSize")
    private int wSize;

    @JsonProperty("wLocation")
    private String wLocation;

    @JsonProperty("wAddress")
    private String wAddress;

    @JsonProperty("wZipcode")
    private String wZipcode;
}
