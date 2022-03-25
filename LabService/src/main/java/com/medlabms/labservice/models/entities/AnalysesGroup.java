package com.medlabms.labservice.models.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import com.medlabms.core.models.entities.Model;
import lombok.Data;

@Data
@Table("analyses_groups")
public class AnalysesGroup extends Model {

    @Id
    private Long id;
    private String name;
    private String description;
}
