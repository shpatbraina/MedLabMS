package com.medlabms.identityservice.models.entities;

import com.medlabms.core.models.entities.Model;
import jakarta.persistence.Entity;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "groups")
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public class Group extends Model {

    private String kcId;
    private String name;
    private String path;
}
