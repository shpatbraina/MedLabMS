package com.medlabms.core.models.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AuditMessageDTO {

    private Long id;
    private String type;
    private String action;
    private String resourceName;
    private String modifiedBy;
    private LocalDateTime date;
}
