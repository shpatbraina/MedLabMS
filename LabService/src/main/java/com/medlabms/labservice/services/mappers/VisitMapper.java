package com.medlabms.labservice.services.mappers;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.mapstruct.ReportingPolicy;

import com.medlabms.labservice.models.dtos.VisitDTO;
import com.medlabms.labservice.models.entities.Visit;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface VisitMapper
{

    VisitDTO entityToDtoModel(Visit entity);

    Visit dtoModelToEntity(VisitDTO visitDTO);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateVisit(Visit visit, @MappingTarget Visit visit1);
}
