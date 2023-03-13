package com.ssafy.snapstory.exception.conflict;

import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.QUIZ_TALE_DUPLICATE;
public class QuizTaleDuplicateException extends AbstractAppException {
    public QuizTaleDuplicateException() { super(QUIZ_TALE_DUPLICATE); }
}
