package com.ssg.wms.warehouse.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssg.wms.global.Enum.EnumStatus;
import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseDTO {
    @JsonProperty("wIndex")
    private Long wIndex;

    @JsonProperty("wCode")
    private int wCode;

    @JsonProperty("wName")
    private String wName;

    @JsonProperty("wSize")
    private int wSize;

    @JsonProperty("wCreatedAt")
    private LocalDateTime wCreatedAt;

    @JsonProperty("wUpdatedAt")
    private LocalDateTime wUpdatedAt;

    @JsonProperty("wLocation")
    private String wLocation;

    @JsonProperty("wAddress")
    private String wAddress;

    @JsonProperty("wZipcode")
    private String wZipcode;

    @JsonProperty("wStatus")
    private EnumStatus wStatus;
}
