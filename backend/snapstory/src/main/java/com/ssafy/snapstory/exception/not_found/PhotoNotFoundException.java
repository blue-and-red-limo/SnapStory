package com.ssafy.snapstory.exception.not_found;

import com.ssafy.snapstory.exception.AbstractAppException;
import static com.ssafy.snapstory.exception.ErrorCode.PHOTO_NOT_FOUND;

public class PhotoNotFoundException extends AbstractAppException {
    public PhotoNotFoundException() {
        super(PHOTO_NOT_FOUND);
    }
}
