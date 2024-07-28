package com.medlabms.auditservice.helpers;

import com.medlabms.auditservice.models.entities.Audit;
import lombok.Getter;

import java.util.Arrays;

@Getter
public enum AuditDescription {

    CREATE_GROUPS(AuditType.GROUPS, AuditAction.CREATE,"Group %s was created by %s"),
    UPDATE_GROUPS(AuditType.GROUPS, AuditAction.UPDATE,"Group %s was updated by %s"),
    DELETE_GROUPS(AuditType.GROUPS, AuditAction.DELETE,"Group %s was deleted by %s"),
    CREATE_USERS(AuditType.USERS, AuditAction.CREATE,"User %s was created by %s"),
    UPDATE_USERS(AuditType.USERS, AuditAction.UPDATE,"User %s was updated by %s"),
    DELETE_USERS(AuditType.USERS, AuditAction.DELETE,"User %s was deleted by %s"),
    CREATE_PATIENTS(AuditType.PATIENTS, AuditAction.CREATE,"Patient %s was created by %s"),
    UPDATE_PATIENTS(AuditType.PATIENTS, AuditAction.UPDATE,"Patient %s was updated by %s"),
    DELETE_PATIENTS(AuditType.PATIENTS, AuditAction.DELETE,"Patient with id %s was deleted by %s"),
    CREATE_ANALYSES_GROUPS(AuditType.ANALYSES_GROUPS, AuditAction.CREATE,"Analyses group %s was created by %s"),
    UPDATE_ANALYSES_GROUPS(AuditType.ANALYSES_GROUPS, AuditAction.UPDATE,"Analyses group %s was updated by %s"),
    DELETE_ANALYSES_GROUPS(AuditType.ANALYSES_GROUPS, AuditAction.DELETE,"Analyses group with id %s was deleted by %s"),
    CREATE_ANALYSES(AuditType.ANALYSES, AuditAction.CREATE,"Analysis %s was created by %s"),
    UPDATE_ANALYSES(AuditType.ANALYSES, AuditAction.UPDATE,"Analysis %s was updated by %s"),
    DELETE_ANALYSES(AuditType.ANALYSES, AuditAction.DELETE,"Analysis with id %s was deleted by %s"),
    CREATE_VISITS(AuditType.VISITS, AuditAction.CREATE,"Visit %s was created by %s"),
    UPDATE_VISITS(AuditType.VISITS, AuditAction.UPDATE,"Visit %s was updated by %s"),
    DELETE_VISITS(AuditType.VISITS, AuditAction.DELETE,"Visit with id %s was deleted by %s");

    private AuditType auditType;
    private AuditAction auditAction;
    private String description;

    AuditDescription(AuditType auditType, AuditAction auditAction, String description) {
        this.auditType = auditType;
        this.auditAction = auditAction;
        this.description = description;
    }

    @Override
    public String toString() {
        return description;
    }

    private static String generateDescription(AuditDescription auditDescription, Audit audit) {
        return auditDescription.toString().formatted(audit.getResourceName(), audit.getModifiedBy());
    }

    public static void setDescription(Audit audit) {

        AuditDescription auditDescription = Arrays.stream(AuditDescription.values())
                .filter(description -> description.getAuditType().equals(AuditType.findByName(audit.getType()))
                        && description.getAuditAction().equals(AuditAction.find(audit.getAction())))
                .findFirst().orElseThrow();

        audit.setDescription(AuditDescription.generateDescription(auditDescription, audit));
    }
}
