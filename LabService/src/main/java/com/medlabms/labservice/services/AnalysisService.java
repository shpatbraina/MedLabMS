package com.medlabms.labservice.services;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.AnalysisDTO;
import com.medlabms.labservice.models.entities.Analysis;
import com.medlabms.labservice.repositories.AnalysisRepository;
import com.medlabms.labservice.services.mappers.AnalysisMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Slf4j
@Service
public class AnalysisService {

    private final AnalysisRepository analysisRepository;
    private final AnalysesGroupService analysesGroupService;
    private final AnalysisMapper analysisMapper;
    private final AuditProducerService auditProducerService;

    public AnalysisService(AnalysisRepository analysisRepository, AnalysesGroupService analysesGroupService,
                           AnalysisMapper analysisMapper, AuditProducerService auditProducerService) {
        this.analysisRepository = analysisRepository;
        this.analysesGroupService = analysesGroupService;
        this.analysisMapper = analysisMapper;
        this.auditProducerService = auditProducerService;
    }

    public List<AnalysisDTO> getAllAnalyses() {
        return analysisRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .stream().map(analysisMapper::entityToDtoModel)
                .toList();
    }

    public Page<AnalysisDTO> getAllAnalyses(PageRequest pageRequest, String filterBy, String search) {
        var analysis = findBy(pageRequest, filterBy, search);
        if(analysis.isEmpty()) {
            return Page.empty(pageRequest);
        }
        var analysisDTOs = analysis
                .stream()
                .map(analysis1 -> {
                    var analysesGroupDTO = analysesGroupService.getAnalysesGroup(analysis1.getAnalysisGroupId());
                    var analysisDTO = analysisMapper.entityToDtoModel(analysis1);
                    analysisDTO.setAnalysisGroupName(analysesGroupDTO.getName());
                    return analysisDTO;
        }).toList();
        return new PageImpl<>(analysisDTOs, pageRequest, countBy(filterBy, search));
    }

    private List<Analysis> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "name" -> analysisRepository.findByNameContainingIgnoreCase(search, pageRequest);
                case "analysisGroupId" -> analysisRepository.findByAnalysisGroupId(Long.parseLong(search), pageRequest);
                default -> analysisRepository.findAllBy(pageRequest);
            };
        }
        return analysisRepository.findAllBy(pageRequest);
    }

    private Long countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "name" -> analysisRepository.countByNameContainingIgnoreCase(search);
                case "analysisGroupId" -> analysisRepository.countByAnalysisGroupId(Long.parseLong(search));
                default -> analysisRepository.count();
            };
        }
        return analysisRepository.count();
    }

    public AnalysisDTO getAnalysis(String id) {
        var analysis = analysisRepository.findById(Long.parseLong(id)).orElseThrow();
        return analysisMapper.entityToDtoModel(analysis);
    }

    public ResponseEntity<Object> createAnalysis(AnalysisDTO analysisDTO) {
        try {
            var analysis = analysisRepository.save(analysisMapper.dtoModelToEntity(analysisDTO));
            auditProducerService.audit(AuditMessageDTO.builder().resourceName(analysisDTO.getName()).action("Create").type("Analyse").build());
            return ResponseEntity.ok(analysisMapper.entityToDtoModel(analysis));
        }catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder()
                    .errorMessage("Failed to create analysis")
                    .build());
        }
    }

    public ResponseEntity<Object> updateAnalysis(Long id, AnalysisDTO analysisDTO) {
        try {
            var analysis = analysisRepository.findById(id).orElseThrow();
            analysisMapper.updateAnalysis(analysisMapper.dtoModelToEntity(analysisDTO), analysis);
            var analysis1 = analysisRepository.save(analysis);
            auditProducerService.audit(AuditMessageDTO.builder()
                    .resourceName(analysisDTO.getName())
                    .action("Update")
                    .type("Analyse")
                    .build());
            return ResponseEntity.ok(analysisMapper.entityToDtoModel(analysis1));
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder()
                    .errorMessage("Failed to update analysis").build());
        }
    }

    public ResponseEntity<Boolean> deleteAnalysis(Long id) {
        try {
            analysisRepository.deleteById(id);
            auditProducerService.audit(
                    AuditMessageDTO.builder()
                            .resourceName(id.toString())
                            .action("Delete")
                            .type("Analyse")
                            .build());
            return ResponseEntity.ok(true);
        }catch (Exception e) {
            log.error(e.getMessage());
            throw new ChildFoundException();
        }
    }
}