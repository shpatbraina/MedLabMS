package com.medlabms.identityservice.repositories;

import com.medlabms.identityservice.models.entities.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface UserRepository extends R2dbcRepository<User, Long> {

    Flux<User> findAllBy(Pageable pageable);
    Mono<User> findByKcId(String keycloakId);
}
