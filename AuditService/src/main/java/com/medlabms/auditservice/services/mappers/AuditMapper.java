package com.medlabms.auditservice.services.mappers;

import com.medlabms.auditservice.models.entities.Audit;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AuditMapper {

    Audit dtoModelToEntity(AuditMessageDTO auditMessageDTO);
}
