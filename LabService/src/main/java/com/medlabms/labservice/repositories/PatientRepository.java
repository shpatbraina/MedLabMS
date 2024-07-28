package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.Patient;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {

    List<Patient> findAllBy(Pageable pageable);
    List<Patient> findByFirstNameContainingIgnoreCase(String firstName, Pageable pageable);
    List<Patient> findByLastNameContainingIgnoreCase(String lastName, Pageable pageable);
    List<Patient> findByPersonalIdContainingIgnoreCase(String personalId, Pageable pageable);
    Long countByFirstNameContainingIgnoreCase(String firstName);
    Long countByLastNameContainingIgnoreCase(String lastName);
    Long countByPersonalIdContainingIgnoreCase(String personalId);
}
