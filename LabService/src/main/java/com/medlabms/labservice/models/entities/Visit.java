package com.medlabms.labservice.models.entities;

import com.medlabms.core.models.entities.Model;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDate;

@Data
@Table("visits")
public class Visit extends Model {

    @Id
    private Long id;
    private Long patientId;
    private LocalDate dateOfVisit;
    private Double totalPrice;
}
