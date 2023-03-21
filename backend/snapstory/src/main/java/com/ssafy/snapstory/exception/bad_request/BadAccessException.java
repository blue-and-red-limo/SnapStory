package com.ssafy.snapstory.exception.bad_request;//package com.ssafy.snapstory.exception.bad_request;

import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.BAD_ACCESS;

public class BadAccessException extends AbstractAppException {
    public BadAccessException() {
        super(BAD_ACCESS);
    }
}
