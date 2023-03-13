package com.ssafy.snapstory.exception.not_found;

import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.QUIZ_TALE_ITEM_LIST_NOT_FOUND;

public class QuizTaleItemListNotFoundException extends AbstractAppException {
    public QuizTaleItemListNotFoundException() { super(QUIZ_TALE_ITEM_LIST_NOT_FOUND); }

}
