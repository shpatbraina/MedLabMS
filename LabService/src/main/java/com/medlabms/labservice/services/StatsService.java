package com.medlabms.labservice.services;

import com.medlabms.labservice.repositories.*;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class StatsService {

    private final PatientRepository patientRepository;
    private final AnalysesGroupRepository analysesGroupRepository;
    private final AnalysisRepository analysisRepository;
    private final VisitRepository visitRepository;
    private final VisitAnalysesRepository visitAnalysesRepository;

    public StatsService(PatientRepository patientRepository, AnalysesGroupRepository analysesGroupRepository,
                        AnalysisRepository analysisRepository, VisitRepository visitRepository,
                        VisitAnalysesRepository visitAnalysesRepository) {
        this.patientRepository = patientRepository;
        this.analysesGroupRepository = analysesGroupRepository;
        this.analysisRepository = analysisRepository;
        this.visitRepository = visitRepository;
        this.visitAnalysesRepository = visitAnalysesRepository;
    }

    public Map<String, Number> getStatistics() {
        Map<String, Number> map = new HashMap<>();

        map.put("patientsCount", patientRepository.count());
        map.put("analysesGroupsCount", analysesGroupRepository.count());
        map.put("analysesCount", analysisRepository.count());
        map.put("visitsCount", visitRepository.count());
        map.put("visitAnalysesCount", visitAnalysesRepository.count());
        return map;
    }
}
