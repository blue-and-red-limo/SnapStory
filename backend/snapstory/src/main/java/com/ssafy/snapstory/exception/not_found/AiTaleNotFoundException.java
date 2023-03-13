package com.ssafy.snapstory.exception.not_found;


import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.AI_TALE_NOT_FOUND;

public class AiTaleNotFoundException extends AbstractAppException {
    public AiTaleNotFoundException() {
        super(AI_TALE_NOT_FOUND);
    }
}
