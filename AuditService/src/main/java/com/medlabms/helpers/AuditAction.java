package com.medlabms.helpers;

import java.util.Arrays;

public enum AuditAction {

    CREATE, UPDATE, DELETE;

    public static AuditAction find(String name) {
        return AuditAction.valueOf(name.toUpperCase());
    }
}
