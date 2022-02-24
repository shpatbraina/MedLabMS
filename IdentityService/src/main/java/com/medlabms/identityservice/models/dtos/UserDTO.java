package com.medlabms.identityservice.models.dtos;

import lombok.Data;

import java.util.List;

@Data
public class UserDTO {

    private String id;
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private List<String> groups;
}
