package com.medlabms.identityservice.models.entities;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Table("users")
public class User {

    @Id
    private Long id;
    private String kcId;
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private Long groupId;
}
