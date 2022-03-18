package com.medlabms.identityservice.services.mapper;

import com.medlabms.identityservice.models.dtos.UserDTO;
import com.medlabms.identityservice.models.entities.User;
import org.keycloak.representations.idm.UserRepresentation;
import org.mapstruct.*;

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

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateUser(User user, @MappingTarget User user1);
}
