package com.medlabms.labservice.services.mappers;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.mapstruct.ReportingPolicy;

import com.medlabms.labservice.models.dtos.VisitAnalysisDTO;
import com.medlabms.labservice.models.entities.VisitAnalysis;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface VisitAnalysesMapper
{

    VisitAnalysisDTO entityToDtoModel(VisitAnalysis entity);

    VisitAnalysis dtoModelToEntity(VisitAnalysisDTO visitAnalysisDTO);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateVisitAnalyses(VisitAnalysis visitAnalysis, @MappingTarget VisitAnalysis visitAnalysis1);

}
