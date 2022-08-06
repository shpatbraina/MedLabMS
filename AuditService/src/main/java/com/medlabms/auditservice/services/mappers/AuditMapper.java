package com.medlabms.auditservice.services.mappers;

import com.medlabms.auditservice.models.dtos.AuditDTO;
import com.medlabms.auditservice.models.entities.Audit;
import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AuditMapper {

    AuditDTO entityToDtoModel(Audit entity);

    Audit dtoModelToEntity(AuditDTO auditDTO);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateAudit(Audit audit, @MappingTarget Audit audit1);
}
