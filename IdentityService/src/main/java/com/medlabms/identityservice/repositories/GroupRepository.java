package com.medlabms.identityservice.repositories;

import com.medlabms.identityservice.models.entities.Group;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.reactive.ReactiveSortingRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface GroupRepository extends ReactiveSortingRepository<Group, Long> {

    Flux<Group> findAllBy(Pageable pageable);
    Mono<Group> findByKcId(String keycloakId);
}
