package com.medlabms.labservice.models.entities;

import com.medlabms.core.models.entities.Model;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import org.springframework.data.annotation.Id;

import java.time.LocalDate;

@Data
@Entity
@Table(name = "visits")
public class Visit extends Model {

    @Id
    private Long id;
    private Long patientId;
    private LocalDate dateOfVisit;
    private Double totalPrice;
}
