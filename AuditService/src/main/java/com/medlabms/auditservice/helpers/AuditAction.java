package com.medlabms.auditservice.helpers;

public enum AuditAction {

    CREATE, UPDATE, DELETE, VISIT_MARKED_AS_PAID, VISIT_MARKED_AS_UNPAID;

    public static AuditAction find(String name) {
        return AuditAction.valueOf(name.toUpperCase());
    }
}
