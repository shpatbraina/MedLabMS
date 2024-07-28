package com.medlabms.auditservice.helpers;

public enum AuditAction {

    CREATE, UPDATE, DELETE;

    public static AuditAction find(String name) {
        return AuditAction.valueOf(name.toUpperCase());
    }
}
