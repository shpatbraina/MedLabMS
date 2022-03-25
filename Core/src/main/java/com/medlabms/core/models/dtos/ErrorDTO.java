package com.medlabms.core.models.dtos;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class ErrorDTO {
    private String errorMessage;
}