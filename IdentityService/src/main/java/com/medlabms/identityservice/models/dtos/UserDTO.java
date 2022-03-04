package com.medlabms.identityservice.models.dtos;

import lombok.Data;

@Data
public class UserDTO {

    private String id;
    private String kcId;
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private Long groupId;
    private String groupName;
}
