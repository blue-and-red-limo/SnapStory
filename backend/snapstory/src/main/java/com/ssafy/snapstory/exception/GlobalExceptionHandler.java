package com.ssafy.snapstory.exception;

import com.ssafy.snapstory.domain.ErrorResponse;
import com.ssafy.snapstory.domain.ResultResponse;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.persistence.PersistenceException;

import static com.ssafy.snapstory.exception.ErrorCode.DATABASE_ERROR;


@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {
    //스프링 벨리데이션 용도
//    @ExceptionHandler(MethodArgumentNotValidException.class)
//    public ResponseEntity<ResultResponse<ErrorResponse>> dtoValidationExceptions(
//            MethodArgumentNotValidException ex) {
//        ObjectError error = ex.getBindingResult().getAllErrors().get(ex.getBindingResult().getAllErrors().size() - 1);
//        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
//                .body(ResultResponse.error(ErrorResponse.of(ErrorCode.valueOf(error.getDefaultMessage()))));
//    }



//    @ExceptionHandler(PersistenceException.class)
//    public ResponseEntity<ResultResponse<ErrorResponse>> persistenceException() {
//        log.error("{} {}", DATABASE_ERROR.name(), DATABASE_ERROR.getMessage());
//        return ResponseEntity.status(DATABASE_ERROR.getHttpStatus())
//                .body(ResultResponse.error(ErrorResponse.of(DATABASE_ERROR)));
//    }


    @ExceptionHandler(AbstractAppException.class)
    public ResponseEntity<ResultResponse<ErrorResponse>> abstractBaseExceptionHandler(AbstractAppException e) {
        log.error("{} {}", e.getErrorCode().name(), e.getMessage());
        return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                .body(ResultResponse.error(e));
    }

    @ExceptionHandler(PersistenceException.class)
    public ResponseEntity<ResultResponse<ErrorResponse>> persistenceException(PersistenceException e) {
        log.error("{} {}", DATABASE_ERROR.name(), DATABASE_ERROR.getMessage());
        e.printStackTrace();
        return ResponseEntity.status(DATABASE_ERROR.getHttpStatus())
                .body(ResultResponse.error(ErrorResponse.of(DATABASE_ERROR)));
    }





}