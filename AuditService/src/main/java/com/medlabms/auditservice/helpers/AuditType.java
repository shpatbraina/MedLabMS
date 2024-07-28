package com.medlabms.auditservice.helpers;

import lombok.Getter;

import java.util.Arrays;

@Getter
public enum AuditType {

    GROUPS("Group"), USERS("User"), PATIENTS("Patient"), ANALYSES_GROUPS("AnalysesGroup"),
    ANALYSES("Analyse"), VISITS("Visit");

    private String name;

    AuditType(String name) {
        this.name = name;
    }

    public static AuditType findByName(String name) {
        return Arrays.stream(AuditType.values()).filter(auditType -> auditType.getName().equalsIgnoreCase(name))
                .findFirst().orElse(null);
    }

    @Override
    public String toString() {
        return name;
    }
}
