package com.ssg.wms.outbound.exception;

// 출고 요청 등록 시 재고 불일치 및 입력 오류에 대한 처리를 위한 예외처리
public class OutboundValidationException extends RuntimeException {
    public OutboundValidationException(String message) {
        super(message);
    }
}
