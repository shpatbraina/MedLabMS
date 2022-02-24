package com.medlabms.identityservice.models.dtos;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class QueryResultDTO {

    private long totalPages;
    private long totalRows;
    private Object data;
}
