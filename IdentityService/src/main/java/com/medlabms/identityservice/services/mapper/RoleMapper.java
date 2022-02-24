package com.medlabms.identityservice.services.mapper;

import com.medlabms.identityservice.models.dtos.RoleDTO;
import org.keycloak.representations.idm.RoleRepresentation;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface RoleMapper {

    RoleDTO entityToModel(RoleRepresentation entity);
}
