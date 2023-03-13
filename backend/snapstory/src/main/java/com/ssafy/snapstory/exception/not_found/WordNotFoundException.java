package com.ssafy.snapstory.exception.not_found;


import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.WORD_NOT_FOUND;

public class WordNotFoundException extends AbstractAppException {
    public WordNotFoundException() {
        super(WORD_NOT_FOUND);
    }
}
