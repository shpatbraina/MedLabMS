package com.medlabms.labservice.services;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.VisitAnalysisDTO;
import com.medlabms.labservice.models.dtos.VisitDTO;
import com.medlabms.labservice.models.entities.Visit;
import com.medlabms.labservice.repositories.VisitAnalysesRepository;
import com.medlabms.labservice.repositories.VisitRepository;
import com.medlabms.labservice.services.mappers.VisitMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

@Slf4j
@Service
public class VisitService {

    private final VisitRepository visitRepository;
    private final PatientService patientService;
    private final AuditProducerService auditProducerService;
    private final VisitAnalysesRepository visitAnalysesRepository;
    private final VisitMapper visitMapper;

    public VisitService(VisitRepository visitRepository, PatientService patientService,
                        AuditProducerService auditProducerService, VisitAnalysesRepository visitAnalysesRepository,
                        VisitMapper visitMapper) {
        this.visitRepository = visitRepository;
        this.patientService = patientService;
        this.auditProducerService = auditProducerService;
        this.visitAnalysesRepository = visitAnalysesRepository;
        this.visitMapper = visitMapper;

    }

    public List<VisitDTO> getAllVisits() {
        var list = visitRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"));
        return list.stream().map(visitMapper::entityToDtoModel).collect(Collectors.toList());
    }

    public Page<VisitDTO> getAllVisits(PageRequest pageRequest, String filterBy, String search) {
        var visits = findBy(pageRequest, filterBy, search);
        if(visits.isEmpty()){
            return Page.empty(pageRequest);
        }
        var dtoList = visits
                .stream()
                .map(visit -> {
                    var visitDTO = visitMapper.entityToDtoModel(visit);
                    visitDTO.setPatientName(patientService.getPatient(visit.getPatientId()).getFullName());
                    return visitDTO;
        }).toList();
        return new PageImpl<>(dtoList, pageRequest, countBy(filterBy, search));
    }

    private List<Visit> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "patientId" -> visitRepository.findByPatientId(Long.parseLong(search), pageRequest);
                case "paid" -> visitRepository.findByPaid(Boolean.parseBoolean(search), pageRequest);
                default -> visitRepository.findAllBy(pageRequest);
            };
        }
        return visitRepository.findAllBy(pageRequest);
    }

    private Long countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()){
            return switch (filterBy) {
                case "patientId" -> visitRepository.countByPatientId(Long.parseLong(search));
                case "paid" -> visitRepository.countByPaid(Boolean.parseBoolean(search));
                default -> visitRepository.count();
            };
        }
        return visitRepository.count();
    }

    public VisitDTO getVisit(String id) {
        var visit = visitRepository.findById(Long.parseLong(id));
        return visitMapper.entityToDtoModel(visit.orElseThrow());
    }

    public ResponseEntity<Object> createVisit(VisitDTO visitDTO) {
        var visit = visitRepository.save(visitMapper.dtoModelToEntity(visitDTO));
        if (visit.getId() != null) {
            auditProducerService
                    .audit(AuditMessageDTO.builder()
                            .resourceName(visit
                                    .getId().toString())
                            .action("Create")
                            .type("Visit")
                            .build());
            return ResponseEntity.ok(visitMapper.entityToDtoModel(visit));
        }
        else {
            return ResponseEntity.badRequest()
                    .body(ErrorDTO.builder()
                    .errorMessage("Failed to create visit")
                    .build());
        }
    }

    public ResponseEntity<Object> updateVisit(Long id, VisitDTO visitDTO) {
        var visit = visitRepository.findById(id).orElseThrow();
        visitMapper.updateVisit(visitMapper.dtoModelToEntity(visitDTO), visit);
        visit = visitRepository.save(visit);
        if(visit.getId() != null){
            auditProducerService.audit(AuditMessageDTO.builder()
                            .resourceName(visit.getId().toString())
                            .action("Update")
                            .type("Visit")
                            .build());
            return ResponseEntity.ok(visitMapper.entityToDtoModel(visit));
        } else {
            return ResponseEntity.badRequest()
                    .body(ErrorDTO.builder()
                            .errorMessage("Failed to update analysis")
                            .build());
        }
    }

    public ResponseEntity<Boolean> deleteVisit(Long id) {
        try {
            visitAnalysesRepository.deleteByVisitId(id);
            visitRepository.deleteById(id);
            auditProducerService.audit(AuditMessageDTO.builder()
                            .resourceName(id.toString())
                            .action("Delete")
                            .type("Visit")
                            .build());
            return ResponseEntity.ok(true);
        }catch (Exception exception) {
            throw new ChildFoundException();
        }
    }

    public Double calculateTotal(Long visitId, List<VisitAnalysisDTO> visitAnalysisDTOs) {
        AtomicReference<Double> total = new AtomicReference<>((double) 0);
        visitAnalysisDTOs.forEach(visitAnalysisDTO -> total.updateAndGet(v -> v + visitAnalysisDTO.getPrice()));

        var visit = visitRepository.findById(visitId).orElseThrow();
        visit.setTotalPrice(total.get());
        visit = visitRepository.save(visit);
        return visit.getTotalPrice();
    }

    public ResponseEntity<Boolean> markAsPaid(Long id, Boolean paid) {
        var visit = visitRepository.findById(id).orElseThrow();
        if(paid.equals(visit.getPaid()))
            return ResponseEntity.ok(false);
        visit.setPaid(paid);
        visitRepository.save(visit);
        auditProducerService.audit(AuditMessageDTO.builder()
                .resourceName(visit.getId().toString())
                .action(paid ? "VISIT_MARKED_AS_PAID" : "VISIT_MARKED_AS_UNPAID")
                .type("Visit")
                .build());
        return ResponseEntity.ok(true);
    }
}