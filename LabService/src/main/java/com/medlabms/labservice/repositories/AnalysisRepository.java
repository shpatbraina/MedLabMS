package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.Analysis;
import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface AnalysisRepository extends R2dbcRepository<Analysis, Long> {

    Flux<Analysis> findAllBy(Pageable pageable);
    Flux<Analysis> findByNameContainingIgnoreCase(String name, Pageable pageable);
    Flux<Analysis> findByAnalysisGroupId(Long analysisGroupId, Pageable pageable);
    Mono<Long> countByNameContainingIgnoreCase(String name);
    Mono<Long> countByAnalysisGroupId(Long analysisGroupId);
}
