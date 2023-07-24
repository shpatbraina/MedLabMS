package com.medlabms.core.models.dtos;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Builder
@Data
public class AuditMessageDTO {

    private Long id;
    private String type;
    private String action;
    private String resourceName;
    private String modifiedBy;
    private LocalDateTime date;
}
