package com.medlabms.identityservice.models.dtos;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class ErrorDTO {
    private String errorMessage;
}