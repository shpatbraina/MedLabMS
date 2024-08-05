package com.medlabms.labservice.models.entities;

import com.medlabms.core.models.entities.Model;
import jakarta.persistence.Entity;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.Table;
import lombok.Data;
import org.springframework.data.annotation.Id;

@Data
@Entity
@Table(name = "analyses_groups")
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public class AnalysesGroup extends Model {

    @Id
    private Long id;
    private String name;
    private String description;
}
