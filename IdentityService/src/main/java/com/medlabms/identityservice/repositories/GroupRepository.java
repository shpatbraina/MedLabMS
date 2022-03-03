package com.medlabms.identityservice.repositories;

import com.medlabms.identityservice.models.entities.Group;
import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface GroupRepository extends R2dbcRepository<Group, Long> {

    Flux<Group> findAllBy(Pageable pageable);
    Mono<Group> findByKcId(String keycloakId);
}
