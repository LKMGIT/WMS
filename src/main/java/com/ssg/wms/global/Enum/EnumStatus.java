package com.ssg.wms.global.Enum;

public enum EnumStatus implements DBValueEnum {

    /* ------ 승인 부분 ------ */
    APPROVED("APPROVED"),
    PENDING("PENDING"),
    REJECTED("REJECTED"),

    /* ------ 답변 부분 ------ */
    ANSWERED("ANSWERED"),
    WORKING("WORKING"),

    /* ------ 삭제 부분 ------ */
    EXIST("EXIST"),
    DELETED("DELETED"),

    /* ------ 근무 부분 ------ */
    OFFLINE("OFFLINE"),
    ONLINE("ONLINE"),

    /* ------ 배송 부분 ------ */
    IN_TRANSIT("IN_TRANSIT"),
    DELIVERED("DELIVERED"),

    /* ------ 회원,관리자 부분 ------ */
    ADMIN("ADMIN"),
    USER("USER"),
    MASTER("MASTER"),


    /* ------ 상품 부분 ------ */
    HEALTH("HEALTH"),
    BEAUTY("BEAUTY"),
    PERFUME("PERFUME"),
    CARE("CARE"),
    FOOD("FOOD"),

    /* ------ 창고 부분 ------ */
    NORMAL("NORMAL"),
    INSPECTION("INSPECTION"),
    CLOSED("CLOSED");

    private String dbValue;
    EnumStatus(String dbValue) {
        this.dbValue = dbValue;
    }

    @Override
    public String getDBValue() {
        return dbValue;
    }

    public static EnumStatus fromDb(String value) {
        for (EnumStatus s : values()) if (s.dbValue.equals(value)) return s;
        throw new IllegalArgumentException("Unknown UserStatus db value: " + value);
    }

}
