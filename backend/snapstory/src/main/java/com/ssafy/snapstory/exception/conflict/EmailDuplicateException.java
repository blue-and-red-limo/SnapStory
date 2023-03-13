package com.ssafy.snapstory.exception.conflict;


import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.EMAIL_DUPLICATE;

public class EmailDuplicateException extends AbstractAppException {
    public EmailDuplicateException() {
        super(EMAIL_DUPLICATE);
    }
}
