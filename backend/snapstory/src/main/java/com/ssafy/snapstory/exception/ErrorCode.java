package com.ssafy.snapstory.exception;

import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.*;

public enum ErrorCode {
    // 유저
    USER_NOT_FOUND(NOT_FOUND, "해당하는 유저를 찾을 수 없습니다."),
    EMAIL_NOT_FOUND(NOT_FOUND, "해당하는 이메일을 찾을 수 없습니다."),
    PHOTO_NOT_FOUND(NOT_FOUND, "해당하는 사진을 찾을 수 없습니다."),
    EMAIL_DUPLICATE(CONFLICT, "이미 가입한 회원입니다."),

    // 단어장
    WORD_NOT_FOUND(NOT_FOUND, "해당하는 단어를 찾을 수 없습니다."),
    WORD_LIST_NOT_FOUND(NOT_FOUND, "단어장에서 해당하는 단어를 찾을 수 없습니다."),
    WORD_LIST_DUPLICATE(CONFLICT, "이미 단어장에 있는 단어입니다."),

    // ai 동화
    AI_TALE_NOT_FOUND(NOT_FOUND, "동화를 찾을 수 없습니다."),
    AI_TALE_DUPLICATE(CONFLICT, "이미 생성된 동화가 있습니다."),

    // 퀴즈 동화
    QUIZ_TALE_DUPLICATE(CONFLICT, "이미 완성한 동화입니다."),
    QUIZ_TALE_NOT_FOUND(NOT_FOUND, "해당하는 동화를 찾을 수 없습니다."),
    QUIZ_TALE_ITEM_LIST_NOT_FOUND(NOT_FOUND, "이 동화에서는 해당 단어를 찾을 수 없습니다."),
    QUIZ_TALE_ITEM_LIST_DUPLICATE(CONFLICT, "이미 그린 그림입니다."),

    // 기타
    BAD_ACCESS(BAD_REQUEST,"잘못된 접근입니다."),
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
