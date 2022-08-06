package com.medlabms.labservice.services.mappers;

import com.medlabms.labservice.models.dtos.PatientDTO;
import com.medlabms.labservice.models.entities.Patient;
import org.mapstruct.*;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface PatientMapper {

    PatientDTO entityToDtoModel(Patient entity);

    Patient dtoModelToEntity(PatientDTO patientDTO);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updatePatient(Patient patient, @MappingTarget Patient patient1);
}
