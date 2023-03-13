package com.ssafy.snapstory.exception.conflict;


import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.AI_TALE_DUPLICATE;

public class AiTaleDuplicateException extends AbstractAppException {
    public AiTaleDuplicateException() {
        super(AI_TALE_DUPLICATE);
    }
}
