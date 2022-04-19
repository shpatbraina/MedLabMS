package com.medlabms.labservice.repositories;


import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;

import com.medlabms.labservice.models.entities.VisitAnalysis;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface VisitAnalysesRepository extends R2dbcRepository<VisitAnalysis, Long> {

    Flux<VisitAnalysis> findAllByVisitId(Pageable pageable, Long visitId);
    Flux<VisitAnalysis> findAllByVisitId(Long visitId);
    Mono<VisitAnalysis> findByVisitIdAndAnalysisId(Long visitId, Long analysisId);
    Mono<Void> deleteByVisitId(Long visitId);
}
