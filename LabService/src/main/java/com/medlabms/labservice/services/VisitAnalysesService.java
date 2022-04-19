package com.medlabms.labservice.services;

import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.VisitAnalysisDTO;
import com.medlabms.labservice.models.entities.VisitAnalysis;
import com.medlabms.labservice.repositories.VisitAnalysesRepository;
import com.medlabms.labservice.services.mappers.VisitAnalysesMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class VisitAnalysesService {

    private VisitAnalysesRepository visitAnalysesRepository;
    private VisitAnalysesMapper visitAnalysesMapper;
    private VisitService visitService;

    public VisitAnalysesService(VisitAnalysesRepository visitAnalysesRepository,
                                VisitAnalysesMapper visitAnalysesMapper, VisitService visitService) {
        this.visitAnalysesRepository = visitAnalysesRepository;
        this.visitAnalysesMapper = visitAnalysesMapper;
        this.visitService = visitService;
    }

    public Mono<List<VisitAnalysisDTO>> getAllVisitAnalyses(Long visitId) {
        return visitAnalysesRepository.findAllByVisitId(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"), visitId)
                .collectList()
                .flatMap(visitAnalyses -> Mono.just(visitAnalyses.stream()
                        .map(visitAnalysesMapper::entityToDtoModel).collect(Collectors.toList())));
    }

    public Mono<ResponseEntity<Object>> createVisitAnalyses(List<VisitAnalysisDTO> visitAnalysisDTOs) {
        return Flux.fromStream(visitAnalysisDTOs.stream().map(visitAnalysesMapper::dtoModelToEntity))
                .collectList().flatMap(visitAnalyses -> visitAnalysesRepository.saveAll(visitAnalyses)
                        .collectList()
                        .doOnError(throwable -> log.error(throwable.getMessage()))
                        .onErrorReturn(Collections.singletonList(new VisitAnalysis()))
                        .flatMap(visitAnalyses1 -> {
                            if (visitAnalyses1.size() == visitAnalyses.size()) {
                                return Flux.fromIterable(visitAnalyses1).map(visitAnalysesMapper::entityToDtoModel)
                                        .collectList()
                                        .flatMap(visitAnalysisDTOS -> visitService.calculateTotal(visitAnalyses1.get(0).getVisitId(), visitAnalysisDTOs))
                                        .flatMap(aDouble -> Mono.just(ResponseEntity.ok(aDouble)));
                            }
                            return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                    .errorMessage("Failed to create visit analyses").build()));
                        }));
    }

    public Mono<ResponseEntity<Object>> updateVisitAnalysis(Long visitId, List<VisitAnalysisDTO> visitAnalysisDTOs) {
        return Flux.fromStream(visitAnalysisDTOs.stream().map(visitAnalysesMapper::dtoModelToEntity))
                .concatMap(visitAnalysis ->
                        visitAnalysesRepository.findByVisitIdAndAnalysisId(visitAnalysis.getVisitId(), visitAnalysis.getAnalysisId())
                                .flatMap(dbVisitAnalysis -> {
                                    visitAnalysesMapper.updateVisitAnalyses(visitAnalysis, dbVisitAnalysis);
                                    return visitAnalysesRepository.save(dbVisitAnalysis);
                                })
                                .switchIfEmpty(visitAnalysesRepository.save(visitAnalysis)))
                .then(Mono.defer(() -> visitAnalysesRepository.findAllByVisitId(visitId).concatMap(dbVisitAnalysis ->
                                Mono.just(visitAnalysisDTOs.stream()
                                                .noneMatch(visitAnalysisDTO -> Objects.equals(visitAnalysisDTO.getVisitId(), dbVisitAnalysis.getVisitId())
                                                        && Objects.equals(visitAnalysisDTO.getAnalysisId(), dbVisitAnalysis.getAnalysisId())))
                                        .flatMap(aBoolean -> aBoolean ? visitAnalysesRepository.delete(dbVisitAnalysis).flatMap(unused -> Mono.just(true)) : Mono.just(aBoolean)))
                        .then(visitService.calculateTotal(visitId, visitAnalysisDTOs))
                        .flatMap(aDouble -> Mono.just(ResponseEntity.ok(aDouble)))));
    }
}