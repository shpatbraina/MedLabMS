package com.medlabms.labservice.services.mappers;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.mapstruct.ReportingPolicy;

import com.medlabms.labservice.models.dtos.AnalysesGroupDTO;
import com.medlabms.labservice.models.entities.AnalysesGroup;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AnalysesGroupMapper {

    AnalysesGroupDTO entityToDtoModel(AnalysesGroup entity);

    AnalysesGroup dtoModelToEntity(AnalysesGroupDTO analysesGroupDTO);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateAnalysesGroup(AnalysesGroup analysesGroup, @MappingTarget AnalysesGroup analysesGroup1);
}
