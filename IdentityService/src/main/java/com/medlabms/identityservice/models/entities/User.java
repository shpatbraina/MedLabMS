package com.medlabms.identityservice.models.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import com.medlabms.core.models.entities.Model;
import lombok.Data;

@Data
@Table("users")
public class User extends Model {

    @Id
    private Long id;
    private String kcId;
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private Long groupId;
}
