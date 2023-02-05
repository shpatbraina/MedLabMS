package com.medlabms.auditservice.models.dtos;

import lombok.Data;

@Data
public class AuditDTO {

    private Long id;
    private String type;
    private String action;
    private String description;
    private String modifiedBy;
    private String date;
}
