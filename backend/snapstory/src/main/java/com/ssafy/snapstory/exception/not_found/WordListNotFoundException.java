package com.ssafy.snapstory.exception.not_found;


import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.WORD_LIST_NOT_FOUND;

public class WordListNotFoundException extends AbstractAppException {
    public WordListNotFoundException() {
        super(WORD_LIST_NOT_FOUND);
    }
}
