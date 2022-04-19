package com.medlabms.labservice.models.dtos;

import lombok.Data;

@Data
public class PatientDTO {

    private Long id;
    private String firstName;
    private String lastName;
    private String birthDate;
    private String birthPlace;
    private String gender;
    private String bloodType;
    private char bloodTypeRh;
    private Long personalId;
    private String email;
    private String phone;

    public String getFullName() {
        return firstName + " " + lastName;
    }
}
