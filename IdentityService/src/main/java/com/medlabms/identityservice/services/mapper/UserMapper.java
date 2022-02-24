package com.medlabms.identityservice.services.mapper;

import com.medlabms.identityservice.models.dtos.UserDTO;
import com.medlabms.identityservice.models.entities.User;
import org.keycloak.representations.idm.UserRepresentation;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface UserMapper {

    @Mappings({
            @Mapping(target = "groups", expression = "java(entity.getGroupName() != null ? List.of(entity.getGroupName()) : null)"),
            @Mapping(target = "id", source = "kcId"),
    })
    UserDTO entityToDtoModel(User entity);

    @Mappings({
            @Mapping(target = "groupName", expression = "java(userDTO.getGroups() != null && !userDTO.getGroups().isEmpty() ? userDTO.getGroups().get(0) : null)"),
            @Mapping(target = "kcId", source = "id"),
            @Mapping(target = "id", ignore = true)
    })
    User dtoModelToEntity(UserDTO userDTO);

    @Mappings({
            @Mapping(target = "groupName", expression="java(userRepresentation.getGroups() != null && !userRepresentation.getGroups().isEmpty() ? userRepresentation.getGroups().get(0) : null)"),
            @Mapping(target = "kcId", source = "id"),
            @Mapping(target = "id", ignore = true)
    })
    User kcEntityToEntity(UserRepresentation userRepresentation);

    UserRepresentation dtoModelToKCEntity(UserDTO userDTO);

    UserDTO kcEntityToDtoModel(UserRepresentation entity);
}
