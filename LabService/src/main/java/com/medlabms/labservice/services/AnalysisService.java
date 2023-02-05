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
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AnalysisService {

    private AnalysisRepository analysisRepository;
    private AnalysesGroupService analysesGroupService;
    private AnalysisMapper analysisMapper;
    private AuditProducerService auditProducerService;

    public AnalysisService(AnalysisRepository analysisRepository, AnalysesGroupService analysesGroupService,
                           AnalysisMapper analysisMapper, AuditProducerService auditProducerService) {
        this.analysisRepository = analysisRepository;
        this.analysesGroupService = analysesGroupService;
        this.analysisMapper = analysisMapper;
        this.auditProducerService = auditProducerService;
    }

    public Mono<List<AnalysisDTO>> getAllAnalyses() {
        return analysisRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .collectList()
                .flatMap(analyses -> Mono.just(analyses.stream()
                        .map(analysisMapper::entityToDtoModel).collect(Collectors.toList())));
    }

    public Mono<Page<AnalysisDTO>> getAllAnalyses(PageRequest pageRequest, String filterBy, String search) {
        return findBy(pageRequest, filterBy, search)
                .flatMap(analysis -> analysesGroupService.getAnalysesGroup(analysis.getAnalysisGroupId())
                        .flatMap(analysesGroupDTO -> {
                            var analysisDTO = analysisMapper.entityToDtoModel(analysis);
                            analysisDTO.setAnalysisGroupName(analysesGroupDTO.getName());
                            return Mono.just(analysisDTO);
                        }))
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    private Flux<Analysis> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "name" -> analysisRepository.findByNameContainingIgnoreCase(search, pageRequest);
                case "analysisGroupId" -> analysisRepository.findByAnalysisGroupId(Long.parseLong(search), pageRequest);
                default -> analysisRepository.findAllBy(pageRequest);
            };
        }
        return analysisRepository.findAllBy(pageRequest);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "name" -> analysisRepository.countByNameContainingIgnoreCase(search);
                case "analysisGroupId" -> analysisRepository.countByAnalysisGroupId(Long.parseLong(search));
                default -> analysisRepository.count();
            };
        }
        return analysisRepository.count();
    }

    public Mono<AnalysisDTO> getAnalysis(String id) {
        return analysisRepository.findById(Long.parseLong(id))
                .flatMap(analysis -> Mono.just(analysisMapper.entityToDtoModel(analysis)));
    }

    public Mono<ResponseEntity<Object>> createAnalysis(AnalysisDTO analysisDTO) {
        return analysisRepository.save(analysisMapper.dtoModelToEntity(analysisDTO))
                .doOnError(throwable -> log.error(throwable.getMessage()))
                .onErrorReturn(new Analysis())
                .flatMap(analysis -> {
                    if (analysis.getId() != null)
                        return auditProducerService.audit(AuditMessageDTO.builder().action("Test").type("test").build())
                                .map(data -> ResponseEntity.ok(analysisMapper.entityToDtoModel(analysis)));
                    return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                            .errorMessage("Failed to create analysis").build()));
                });
    }

    public Mono<ResponseEntity<Object>> updateAnalysis(Long id, AnalysisDTO analysisDTO) {
        return analysisRepository.findById(id)
                .flatMap(analysis -> {
                    analysisMapper.updateAnalysis(analysisMapper.dtoModelToEntity(analysisDTO), analysis);
                    return analysisRepository.save(analysis)
                            .onErrorReturn(new Analysis())
                            .flatMap(analysis1 -> {
                                if (analysis1.getId() != null)
                                    return Mono.just(ResponseEntity.ok(analysisMapper.entityToDtoModel(analysis1)));
                                return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                        .errorMessage("Failed to update analysis").build()));
                            });
                });
    }

    public Mono<ResponseEntity<Boolean>> deleteAnalysis(Long id) {
        return analysisRepository.deleteById(id)
                .flatMap(unused -> Mono.just(ResponseEntity.ok(true)))
                .onErrorResume(throwable -> {
                    throw new ChildFoundException();
                });
    }
}