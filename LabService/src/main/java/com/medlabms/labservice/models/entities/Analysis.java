package com.medlabms.labservice.models.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import com.medlabms.core.models.entities.Model;
import lombok.Data;

@Data
@Table("analyses")
public class Analysis extends Model {

    @Id
    private Long id;
    private String name;
    private String description;
    private String metric;
    private String metricRange;
    private Double price;
    private Long analysisGroupId;
}
