package com.medlabms.labservice.models.dtos;

import lombok.Data;

@Data
public class VisitAnalysisDTO
{

	private Long id;
	private Long visitId;
	private Long analysisId;
	private String name;
	private String value;
	private String metric;
	private String metricRange;
	private Double price;
}
