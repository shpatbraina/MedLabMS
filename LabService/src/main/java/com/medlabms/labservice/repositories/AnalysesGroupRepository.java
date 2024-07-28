package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.AnalysesGroup;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnalysesGroupRepository extends JpaRepository<AnalysesGroup, Long> {

    List<AnalysesGroup> findAllBy(Pageable pageable);
    List<AnalysesGroup> findByNameContainingIgnoreCase(String name, Pageable pageable);

    Long countByNameContainingIgnoreCase(String name);
}
