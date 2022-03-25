package com.medlabms.labservice.repositories;


import org.springframework.data.domain.Pageable;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;

import com.medlabms.labservice.models.entities.Patient;
import reactor.core.publisher.Flux;

@Repository
public interface PatientRepository extends R2dbcRepository<Patient, Long> {

    Flux<Patient> findAllBy(Pageable pageable);
}
