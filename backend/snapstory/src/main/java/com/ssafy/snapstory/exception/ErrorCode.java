package com.ssafy.snapstory.exception;

import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.*;

public enum ErrorCode {

    USER_NOT_FOUND(NOT_FOUND, "해당하는 유저를 찾을 수 없습니다."),
    EMAIL_NOT_FOUND(NOT_FOUND, "해당하는 이메일을 찾을 수 없습니다."),
    EMAIL_DUPLICATE(CONFLICT, "이미 가입된 회원이 존재합니다."),

    WORD_NOT_FOUND(NOT_FOUND, "해당하는 단어를 찾을 수 없습니다."),
    WORD_LIST_NOT_FOUND(NOT_FOUND, "단어장을 찾을 수 없습니다."),

    DATABASE_ERROR(INTERNAL_SERVER_ERROR, "데이터베이스 에러");


    private final HttpStatus httpStatus;
    private final String message;

    ErrorCode(HttpStatus httpStatus, String message) {
        this.httpStatus = httpStatus;
        this.message = message;
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

    public String getMessage() {
        return message;
    }
}
