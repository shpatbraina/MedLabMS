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
    Flux<User> findByFirstNameContainingIgnoreCase(String firstName, Pageable pageable);
    Flux<User> findByLastNameContainingIgnoreCase(String lastName, Pageable pageable);
    Flux<User> findByEmailContainingIgnoreCase(String email, Pageable pageable);
    Flux<User> findByUsernameContainingIgnoreCase(String username, Pageable pageable);
    Flux<User> findByGroupId(Long groupId, Pageable pageable);
    Mono<User> findByKcId(String keycloakId);


    Mono<Long> countByFirstNameContainingIgnoreCase(String firstName);
    Mono<Long> countByLastNameContainingIgnoreCase(String lastName);
    Mono<Long> countByEmailContainingIgnoreCase(String email);
    Mono<Long> countByUsernameContainingIgnoreCase(String username);
    Mono<Long> countByGroupId(Long groupId);
}
