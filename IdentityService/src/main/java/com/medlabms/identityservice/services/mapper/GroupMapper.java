package com.medlabms.identityservice.services.mapper;

import com.medlabms.identityservice.models.dtos.GroupDTO;
import com.medlabms.identityservice.models.entities.Group;
import org.keycloak.representations.idm.GroupRepresentation;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface GroupMapper {

    @Mappings({
//            @Mapping(target = "id", source = "kcId")
    })
    GroupDTO entityToDtoModel(Group entity);

    @Mappings({
            @Mapping(target = "kcId", source = "id"),
            @Mapping(target = "id", ignore = true)
    })
    Group dtoModelToEntity(GroupDTO groupDTO);

    @Mappings({
            @Mapping(target = "kcId", source = "id"),
            @Mapping(target = "id", ignore = true)
    })
    Group kcEntityToEntity(GroupRepresentation groupRepresentation);

    GroupRepresentation dtoModelToKCEntity(GroupDTO groupDTO);

    GroupDTO kcEntityToDtoModel(GroupRepresentation entity);
}
