package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.Analysis;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnalysisRepository extends JpaRepository<Analysis, Long> {

    List<Analysis> findAllBy(Pageable pageable);
    List<Analysis> findByNameContainingIgnoreCase(String name, Pageable pageable);
    List<Analysis> findByAnalysisGroupId(Long analysisGroupId, Pageable pageable);
    Long countByNameContainingIgnoreCase(String name);
    Long countByAnalysisGroupId(Long analysisGroupId);
}
