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


    UserDTO entityToDtoModel(User entity);

    User dtoModelToEntity(UserDTO userDTO);

    @Mappings({
            @Mapping(target = "kcId", source = "id"),
            @Mapping(target = "id", ignore = true)
    })
    User kcEntityToEntity(UserRepresentation userRepresentation);
    @Mappings({
            @Mapping(target = "id", source = "kcId")
    })
    UserRepresentation dtoModelToKCEntity(UserDTO userDTO);

    UserDTO kcEntityToDtoModel(UserRepresentation entity);
}
