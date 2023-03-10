package com.ssafy.snapstory.exception.conflict;

import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.QUIZ_TALE_ITEM_LIST_DUPLICATE;

public class QuizTaleItemListDuplicateException extends AbstractAppException {
    public QuizTaleItemListDuplicateException() { super(QUIZ_TALE_ITEM_LIST_DUPLICATE); }
}
