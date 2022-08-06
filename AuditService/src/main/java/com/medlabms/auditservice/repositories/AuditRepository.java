package com.medlabms.auditservice.repositories;

import com.medlabms.auditservice.models.entities.Audit;
import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Repository
public interface AuditRepository extends R2dbcRepository<Audit, Long> {

    Flux<Audit> findAllBy(Pageable pageable);
    Flux<Audit> findByTypeContainingIgnoreCase(String type, Pageable pageable);
    Flux<Audit> findByActionContainingIgnoreCase(String action, Pageable pageable);
    Flux<Audit> findByModifiedByContainingIgnoreCase(String modifiedBy, Pageable pageable);
    Flux<Audit> findByDateContainingIgnoreCase(LocalDateTime date, Pageable pageable);
    Mono<Long> countByTypeContainingIgnoreCase(String type);
    Mono<Long> countByActionContainingIgnoreCase(String action);
    Mono<Long> countByModifiedByContainingIgnoreCase(String modifiedBy);
    Mono<Long> countByDateContainingIgnoreCase(LocalDateTime date);
}
