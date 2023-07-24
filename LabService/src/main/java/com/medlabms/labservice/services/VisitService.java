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
import org.springframework.data.r2dbc.core.R2dbcEntityTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

@Slf4j
@Service
public class VisitService {

    private VisitRepository visitRepository;
    private PatientService patientService;
    private AuditProducerService auditProducerService;
    private VisitAnalysesRepository visitAnalysesRepository;
    private VisitMapper visitMapper;

    public VisitService(VisitRepository visitRepository, PatientService patientService,
                        AuditProducerService auditProducerService, VisitAnalysesRepository visitAnalysesRepository,
                        VisitMapper visitMapper) {
        this.visitRepository = visitRepository;
        this.patientService = patientService;
        this.auditProducerService = auditProducerService;
        this.visitAnalysesRepository = visitAnalysesRepository;
        this.visitMapper = visitMapper;

    }

    public Mono<List<VisitDTO>> getAllVisits() {
        return visitRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .collectList()
                .flatMap(visits -> Mono.just(visits.stream()
                        .map(visitMapper::entityToDtoModel).collect(Collectors.toList())));
    }

    public Mono<Page<VisitDTO>> getAllVisits(PageRequest pageRequest, String filterBy, String search) {
        return findBy(pageRequest, filterBy, search)
                .flatMap(visit -> patientService.getPatient(visit.getPatientId())
                        .flatMap(patientDTO -> {
                            var visitDTO = visitMapper.entityToDtoModel(visit);
                            visitDTO.setPatientName(patientDTO.getFullName());
                            return Mono.just(visitDTO);
                        }))
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    private Flux<Visit> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "patientId".equals(filterBy)) {
            return visitRepository.findByPatientId(Long.parseLong(search), pageRequest);
        }
        return visitRepository.findAllBy(pageRequest);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "patientId".equals(filterBy)) {
            return visitRepository.countByPatientId(Long.parseLong(search));
        }
        return visitRepository.count();
    }

    public Mono<VisitDTO> getVisit(String id) {
        return visitRepository.findById(Long.parseLong(id))
                .flatMap(visit -> Mono.just(visitMapper.entityToDtoModel(visit)));
    }

    public Mono<ResponseEntity<Object>> createVisit(VisitDTO visitDTO) {
        return visitRepository.save(visitMapper.dtoModelToEntity(visitDTO))
                .doOnError(throwable -> log.error(throwable.getMessage()))
                .onErrorReturn(new Visit())
                .flatMap(visit -> {
                    if (visit.getId() != null)
                        return auditProducerService.audit(AuditMessageDTO.builder().resourceName(visit.getId().toString()).action("Create").type("Visit").build())
                                .then(Mono.just(ResponseEntity.ok(visitMapper.entityToDtoModel(visit))));
                    return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                            .errorMessage("Failed to create visit").build()));
                });
    }

    public Mono<ResponseEntity<Object>> updateVisit(Long id, VisitDTO visitDTO) {
        return visitRepository.findById(id)
                .flatMap(visit -> {
                    visitMapper.updateVisit(visitMapper.dtoModelToEntity(visitDTO), visit);
                    return visitRepository.save(visit)
                            .onErrorReturn(new Visit())
                            .flatMap(visit1 -> {
                                if (visit1.getId() != null)
                                    return auditProducerService.audit(AuditMessageDTO.builder().resourceName(visit1.getId().toString()).action("Update").type("Visit").build())
                                            .then(Mono.just(ResponseEntity.ok(visitMapper.entityToDtoModel(visit1))));
                                return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                        .errorMessage("Failed to update analysis").build()));
                            });
                });
    }

    public Mono<ResponseEntity<Boolean>> deleteVisit(Long id) {
        return visitAnalysesRepository.deleteByVisitId(id)
                .then(visitRepository.deleteById(id)
                        .then(auditProducerService.audit(AuditMessageDTO.builder().resourceName(id.toString()).action("Delete").type("Visit").build())
                                .map(unused1 -> ResponseEntity.ok(true)))
                        .onErrorResume(throwable -> {
                            throw new ChildFoundException();
                        }));
    }

    public Mono<Double> calculateTotal(Long visitId, List<VisitAnalysisDTO> visitAnalysisDTOs) {
        AtomicReference<Double> total = new AtomicReference<>((double) 0);
        visitAnalysisDTOs.forEach(visitAnalysisDTO -> total.updateAndGet(v -> v + visitAnalysisDTO.getPrice()));

        return visitRepository.findById(visitId)
                .flatMap(visit -> {
                    visit.setTotalPrice(total.get());
                    return visitRepository.save(visit);
                }).map(Visit::getTotalPrice).flatMap(Mono::just);
    }
}