package com.medlabms.labservice.repositories;


import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;

import com.medlabms.labservice.models.entities.Analysis;
import reactor.core.publisher.Flux;

@Repository
public interface AnalysisRepository extends R2dbcRepository<Analysis, Long> {

    Flux<Analysis> findAllBy(Pageable pageable);
}
