package com.ssafy.snapstory.exception.not_found;

import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.QUIZ_TALE_NOT_FOUND;

public class QuizTaleNotFoundException extends AbstractAppException {
    public QuizTaleNotFoundException() {
        super(QUIZ_TALE_NOT_FOUND);
    }

}
