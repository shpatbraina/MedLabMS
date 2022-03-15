package com.medlabms.identityservice.exceptions;

import org.springframework.dao.DataIntegrityViolationException;

public class ChildFoundException extends DataIntegrityViolationException {

    public ChildFoundException() {
        super("Child found while trying to delete!");
    }

    public ChildFoundException(String msg) {
        super(msg);
    }

    public ChildFoundException(String msg, Throwable cause) {
        super(msg, cause);
    }
}
