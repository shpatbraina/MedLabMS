package com.medlabms.identityservice.services.mappers;

import org.keycloak.representations.idm.RoleRepresentation;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import com.medlabms.identityservice.models.dtos.RoleDTO;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface RoleMapper {

    RoleDTO entityToModel(RoleRepresentation entity);
}
