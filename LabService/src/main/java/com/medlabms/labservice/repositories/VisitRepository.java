package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.Visit;
import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface VisitRepository extends R2dbcRepository<Visit, Long> {

    Flux<Visit> findAllBy(Pageable pageable);
    Flux<Visit> findByPatientId(Long patientId, Pageable pageable);

    Mono<Long> countByPatientId(Long patientId);
}