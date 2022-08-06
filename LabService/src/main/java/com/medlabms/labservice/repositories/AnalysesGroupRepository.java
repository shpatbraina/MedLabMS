package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.AnalysesGroup;
import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface AnalysesGroupRepository extends R2dbcRepository<AnalysesGroup, Long> {

    Flux<AnalysesGroup> findAllBy(Pageable pageable);
    Flux<AnalysesGroup> findByNameContainingIgnoreCase(String name, Pageable pageable);

    Mono<Long> countByNameContainingIgnoreCase(String name);
}
