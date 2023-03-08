package com.ssafy.snapstory.exception.not_found;


import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.EMAIL_NOT_FOUND;

public class EmailNotFoundException extends AbstractAppException {
    public EmailNotFoundException() {
        super(EMAIL_NOT_FOUND);
    }
}
