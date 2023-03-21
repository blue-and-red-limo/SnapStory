package com.ssafy.snapstory.exception.conflict;

import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.WORD_LIST_DUPLICATE;

public class WordListDuplicateException extends AbstractAppException {
    public WordListDuplicateException() {
        super(WORD_LIST_DUPLICATE);
    }

}
