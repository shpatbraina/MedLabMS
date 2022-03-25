package com.medlabms.labservice.models.entities;

import java.time.LocalDate;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import com.medlabms.core.models.entities.Model;
import lombok.Data;

@Data
@Table("patients")
public class Patient extends Model {

    @Id
    private Long id;
    private String firstName;
    private String lastName;
    private LocalDate birthDate;
    private String birthPlace;
    private String gender;
    private String bloodType;
    private char bloodTypeRh;
    private Long personalId;
    private String email;
    private String phone;
}
