package com.medlabms.labservice.models.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import com.medlabms.core.models.entities.Model;
import lombok.Data;

@Data
@Table("visits_analyses")
public class VisitAnalysis extends Model {

    @Id
    private Long id;
    private Long visitId;
    private Long analysisId;
    private String name;
    private String value;
    private String metric;
    private String metricRange;
    private Double price;
}
