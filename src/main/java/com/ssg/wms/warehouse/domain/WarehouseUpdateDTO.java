package com.ssg.wms.warehouse.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssg.wms.global.Enum.EnumStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseUpdateDTO {
    @JsonProperty("wIndex")
    private Long wIndex;

    @JsonProperty("wName")
    private String wName;

    @JsonProperty("wLocation")
    private String wLocation;

    @JsonProperty("wAddress")
    private String wAddress;

    @JsonProperty("wZipcode")
    private String wZipcode;

    @JsonProperty("wStatus")
    private EnumStatus wStatus;
}
