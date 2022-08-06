package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.Patient;
import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface PatientRepository extends R2dbcRepository<Patient, Long> {

    Flux<Patient> findAllBy(Pageable pageable);
    Flux<Patient> findByFirstNameContainingIgnoreCase(String firstName, Pageable pageable);
    Flux<Patient> findByLastNameContainingIgnoreCase(String lastName, Pageable pageable);
    Flux<Patient> findByPersonalIdContainingIgnoreCase(String personalId, Pageable pageable);
    Mono<Long> countByFirstNameContainingIgnoreCase(String firstName);
    Mono<Long> countByLastNameContainingIgnoreCase(String lastName);
    Mono<Long> countByPersonalIdContainingIgnoreCase(String personalId);
}
