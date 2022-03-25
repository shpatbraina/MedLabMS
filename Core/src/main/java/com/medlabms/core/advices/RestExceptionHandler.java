package com.medlabms.core.advices;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.ErrorDTO;
import lombok.extern.slf4j.Slf4j;

@Component
@ControllerAdvice(annotations = RestController.class)
@Slf4j
@Validated
public class RestExceptionHandler {

    @ExceptionHandler(value = {ChildFoundException.class})
    protected ResponseEntity<Object> handleMissingUserGroupHeaders(Exception ex) {
        log.error(ex.getLocalizedMessage());
        return ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(ex.getMessage()).build());
    }

}