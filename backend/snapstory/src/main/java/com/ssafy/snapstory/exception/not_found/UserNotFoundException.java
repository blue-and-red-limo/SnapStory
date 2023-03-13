package com.ssafy.snapstory.exception.not_found;


import com.ssafy.snapstory.exception.AbstractAppException;

import static com.ssafy.snapstory.exception.ErrorCode.USER_NOT_FOUND;

public class UserNotFoundException extends AbstractAppException {
    public UserNotFoundException() {
        super(USER_NOT_FOUND);
    }
}
