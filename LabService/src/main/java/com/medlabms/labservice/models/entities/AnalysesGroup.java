package com.medlabms.labservice.models.entities;

import com.medlabms.core.models.entities.Model;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import org.springframework.data.annotation.Id;

@Data
@Entity
@Table(name = "analyses_groups")
public class AnalysesGroup extends Model {

    @Id
    private Long id;
    private String name;
    private String description;
}
