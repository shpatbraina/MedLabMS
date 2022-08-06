package com.medlabms.auditservice.models.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Data
@Table("audits")
public class Audit {

    @Id
    private Long id;
    private String type;
    private String action;
    private String description;
    private String modifiedBy;
    private LocalDateTime date;
}
