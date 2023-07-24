package com.medlabms.repositories;

import com.medlabms.models.entities.Audit;
import io.micronaut.data.annotation.Repository;
import io.micronaut.data.model.Pageable;
import io.micronaut.data.repository.reactive.ReactorPageableRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface AuditRepository extends ReactorPageableRepository<Audit, Long> {

    Flux<Audit> find(Pageable pageable);
    Flux<Audit> findByActionContainsIgnoreCase(String action, Pageable pageable);
    Flux<Audit> findByTypeContainsIgnoreCase(String type, Pageable pageable);
    Flux<Audit> findByModifiedByContainsIgnoreCase(String modifiedBy, Pageable pageable);

    Mono<Long> countByActionContainsIgnoreCase(String action);
    Mono<Long> countByTypeContainsIgnoreCase(String type);
    Mono<Long> countByModifiedByContainsIgnoreCase(String modifiedBy);
}
