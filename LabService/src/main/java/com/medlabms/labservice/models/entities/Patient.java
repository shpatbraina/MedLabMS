package com.medlabms.labservice.models.entities;

import com.medlabms.core.models.entities.Model;
import jakarta.persistence.Entity;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.Table;
import lombok.Data;
import org.springframework.data.annotation.Id;

import java.time.LocalDate;

@Data
@Entity
@Table(name = "patients")
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
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
