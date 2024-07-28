package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.Visit;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VisitRepository extends JpaRepository<Visit, Long> {

    List<Visit> findAllBy(Pageable pageable);
    List<Visit> findByPatientId(Long patientId, Pageable pageable);

    Long countByPatientId(Long patientId);
}