package com.ssg.wms.global.controller.advice;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
class GlobalErrorAdvice {
    @ExceptionHandler(Exception.class)
    @ResponseBody
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    String any(Exception e){
        e.printStackTrace(); // 콘솔에도 찍기
        return "ERROR: " + e.getClass().getSimpleName() + " - " + String.valueOf(e.getMessage());
    }
}
