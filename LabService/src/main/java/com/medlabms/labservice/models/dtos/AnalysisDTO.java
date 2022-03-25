package com.medlabms.labservice.models.dtos;

import lombok.Data;

@Data
public class AnalysisDTO {

    private Long id;
    private String name;
    private String description;
    private String metric;
    private String metricRange;
    private Double price;
    private Long analysisGroupId;
    private String analysisGroupName;
}
