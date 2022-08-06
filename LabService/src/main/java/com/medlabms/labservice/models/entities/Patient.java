package com.medlabms.labservice.models.entities;

import com.medlabms.core.models.entities.Model;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDate;

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
    private String personalId;
    private String email;
    private String phone;
}
