package com.medlabms.identityservice.models.entities;

import com.medlabms.core.models.entities.Model;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Table("groups")
public class Group extends Model {

    @Id
    private Long id;
    private String kcId;
    private String name;
    private String path;
}
