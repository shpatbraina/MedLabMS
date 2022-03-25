package com.medlabms.labservice.services.mappers;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.mapstruct.ReportingPolicy;

import com.medlabms.labservice.models.dtos.AnalysisDTO;
import com.medlabms.labservice.models.entities.Analysis;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AnalysisMapper {

    AnalysisDTO entityToDtoModel(Analysis entity);

    Analysis dtoModelToEntity(AnalysisDTO analysisDTO);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateAnalysis(Analysis analysis, @MappingTarget Analysis analysis1);
}
