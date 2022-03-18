package com.medlabms.core.advices;

import com.medlabms.core.exceptions.ChildFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;

@Component
@ControllerAdvice(annotations = RestController.class)
@Slf4j
@Validated
public class RestExceptionHandler {

    @ExceptionHandler(value = {ChildFoundException.class})
    protected ResponseEntity<Object> handleMissingUserGroupHeaders(Exception ex) {
        log.error(ex.getLocalizedMessage());
        return ResponseEntity.badRequest().body(ex.getMessage());
    }

}