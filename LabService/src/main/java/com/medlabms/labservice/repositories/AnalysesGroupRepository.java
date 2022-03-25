package com.medlabms.labservice.repositories;


import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;

import com.medlabms.labservice.models.entities.AnalysesGroup;
import reactor.core.publisher.Flux;

@Repository
public interface AnalysesGroupRepository extends R2dbcRepository<AnalysesGroup, Long> {

    Flux<AnalysesGroup> findAllBy(Pageable pageable);
}
