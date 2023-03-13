package com.ssafy.snapstory.exception;
import com.ssafy.snapstory.exception.*;
public abstract class AbstractAppException extends RuntimeException {
    private final ErrorCode errorCode;

    public AbstractAppException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public ErrorCode getErrorCode() {
        return errorCode;
    }
}
