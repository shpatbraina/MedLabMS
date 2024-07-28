package com.medlabms.labservice.repositories;


import com.medlabms.labservice.models.entities.VisitAnalysis;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VisitAnalysesRepository extends JpaRepository<VisitAnalysis, Long> {

    List<VisitAnalysis> findAllByVisitId(Pageable pageable, Long visitId);
    List<VisitAnalysis> findAllByVisitId(Long visitId);
    VisitAnalysis findByVisitIdAndAnalysisId(Long visitId, Long analysisId);
    void deleteByVisitId(Long visitId);
}
