package com.ssg.wms.login;

public enum LoginResult {
    SUCCESS,
    NOT_FOUND,        // 아이디 없음
    NOT_APPROVED,     // APPROVED가 아님 (PENDING/REJECTED 등)
    BAD_CREDENTIALS   // 비밀번호 불일치
}

