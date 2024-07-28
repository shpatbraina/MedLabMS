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

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class VisitAnalysesService {

    private final VisitAnalysesRepository visitAnalysesRepository;
    private final VisitAnalysesMapper visitAnalysesMapper;
    private final VisitService visitService;

    public VisitAnalysesService(VisitAnalysesRepository visitAnalysesRepository,
                                VisitAnalysesMapper visitAnalysesMapper, VisitService visitService) {
        this.visitAnalysesRepository = visitAnalysesRepository;
        this.visitAnalysesMapper = visitAnalysesMapper;
        this.visitService = visitService;
    }

    public List<VisitAnalysisDTO> getAllVisitAnalyses(Long visitId) {
        return visitAnalysesRepository.findAllByVisitId(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"), visitId)
                .stream().map(visitAnalysesMapper::entityToDtoModel).collect(Collectors.toList());
    }

    public ResponseEntity<Object> createVisitAnalyses(List<VisitAnalysisDTO> visitAnalysisDTOs) {
        var list = visitAnalysisDTOs.stream().map(visitAnalysesMapper::dtoModelToEntity).toList();
        try {
            var visitAnalyses = visitAnalysesRepository.saveAll(list);
            var total = visitService.calculateTotal(visitAnalyses.getFirst().getVisitId(), visitAnalysisDTOs);
            return ResponseEntity.ok(total);
        }catch (Exception exception) {
            log.error(exception.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder()
                    .errorMessage("Failed to create visit analyses").build());
        }
    }

    public ResponseEntity<Object> updateVisitAnalysis(Long visitId, List<VisitAnalysisDTO> visitAnalysisDTOs) {
        // Assuming visitAnalysisDTOs is a List<VisitAnalysisDTO>
        List<VisitAnalysis> visitAnalyses = visitAnalysisDTOs.stream()
                .map(visitAnalysesMapper::dtoModelToEntity)
                .toList();

        visitAnalyses.forEach(visitAnalysis -> {
            var dbVisitAnalysis = visitAnalysesRepository
                    .findByVisitIdAndAnalysisId(visitAnalysis.getVisitId(), visitAnalysis.getAnalysisId());

            if (Objects.nonNull(dbVisitAnalysis)) {
                visitAnalysesMapper.updateVisitAnalyses(visitAnalysis, dbVisitAnalysis);
                visitAnalysesRepository.save(dbVisitAnalysis);
            } else {
                visitAnalysesRepository.save(visitAnalysis);
            }
        });

        var dbVisitAnalyses = visitAnalysesRepository.findAllByVisitId(visitId);

        boolean allDeleted = dbVisitAnalyses.stream()
                .noneMatch(dbVisitAnalysis ->
                        visitAnalysisDTOs.stream()
                                .anyMatch(visitAnalysisDTO ->
                                        Objects.equals(visitAnalysisDTO.getVisitId(), dbVisitAnalysis.getVisitId())
                                                && Objects.equals(visitAnalysisDTO.getAnalysisId(), dbVisitAnalysis.getAnalysisId())));

        if (allDeleted) {
            visitAnalysesRepository.deleteAll(dbVisitAnalyses);
        }

        double total = visitService.calculateTotal(visitId, visitAnalysisDTOs);
        return ResponseEntity.ok(total);
    }

//    public Mono<ResponseEntity<Object>> updateVisitAnalysis(Long visitId, List<VisitAnalysisDTO> visitAnalysisDTOs) {
//        return Flux.fromStream(visitAnalysisDTOs.stream().map(visitAnalysesMapper::dtoModelToEntity))
//                .concatMap(visitAnalysis ->
//                        visitAnalysesRepository.findByVisitIdAndAnalysisId(visitAnalysis.getVisitId(), visitAnalysis.getAnalysisId())
//                                .flatMap(dbVisitAnalysis -> {
//                                    visitAnalysesMapper.updateVisitAnalyses(visitAnalysis, dbVisitAnalysis);
//                                    return visitAnalysesRepository.save(dbVisitAnalysis);
//                                })
//                                .switchIfEmpty(visitAnalysesRepository.save(visitAnalysis)))
//                .then(Mono.defer(() -> visitAnalysesRepository.findAllByVisitId(visitId).concatMap(dbVisitAnalysis ->
//                                Mono.just(visitAnalysisDTOs.stream()
//                                                .noneMatch(visitAnalysisDTO -> Objects.equals(visitAnalysisDTO.getVisitId(), dbVisitAnalysis.getVisitId())
//                                                        && Objects.equals(visitAnalysisDTO.getAnalysisId(), dbVisitAnalysis.getAnalysisId())))
//                                        .flatMap(aBoolean -> aBoolean ? visitAnalysesRepository.delete(dbVisitAnalysis).flatMap(unused -> Mono.just(true)) : Mono.just(aBoolean)))
//                        .then(visitService.calculateTotal(visitId, visitAnalysisDTOs))
//                        .flatMap(aDouble -> Mono.just(ResponseEntity.ok(aDouble)))));
//    }
}