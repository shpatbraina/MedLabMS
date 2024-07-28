package com.medlabms.labservice.models.entities;

import com.medlabms.core.models.entities.Model;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import org.springframework.data.annotation.Id;

@Data
@Entity
@Table(name = "visits_analyses")
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
