package com.medlabms.labservice.models.dtos;

import lombok.Data;

@Data
public class VisitDTO
{

    private Long id;
    private String patientId;
    private String patientName;
    private String dateOfVisit;
    private Double totalPrice;
}
