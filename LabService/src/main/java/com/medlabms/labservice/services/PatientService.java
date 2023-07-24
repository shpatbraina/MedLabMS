package com.medlabms.labservice.services;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.PatientDTO;
import com.medlabms.labservice.models.entities.Patient;
import com.medlabms.labservice.repositories.PatientRepository;
import com.medlabms.labservice.services.mappers.PatientMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class PatientService {

    private AuditProducerService auditProducerService;
    private PatientRepository patientRepository;
    private PatientMapper patientMapper;

    public PatientService(AuditProducerService auditProducerService, PatientRepository patientRepository, PatientMapper patientMapper) {
        this.auditProducerService = auditProducerService;
        this.patientRepository = patientRepository;
        this.patientMapper = patientMapper;
    }

    public Mono<List<PatientDTO>> getAllPatients() {
        return patientRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .collectList()
                .flatMap(patients -> Mono.just(patients.stream()
                        .map(patientMapper::entityToDtoModel).collect(Collectors.toList())));
    }

    public Mono<Page<PatientDTO>> getAllPatients(PageRequest pageRequest, String filterBy, String search) {
        return findBy(pageRequest, filterBy, search)
                .flatMap(patient -> Mono.just(patientMapper.entityToDtoModel(patient)))
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    private Flux<Patient> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "firstName" -> patientRepository.findByFirstNameContainingIgnoreCase(search, pageRequest);
                case "lastName" -> patientRepository.findByLastNameContainingIgnoreCase(search, pageRequest);
                case "personalId" -> patientRepository.findByPersonalIdContainingIgnoreCase(search, pageRequest);
                default -> patientRepository.findAllBy(pageRequest);
            };
        }
        return patientRepository.findAllBy(pageRequest);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "firstName" -> patientRepository.countByFirstNameContainingIgnoreCase(search);
                case "lastName" -> patientRepository.countByLastNameContainingIgnoreCase(search);
                case "personalId" -> patientRepository.countByPersonalIdContainingIgnoreCase(search);
                default -> patientRepository.count();
            };
        }
        return patientRepository.count();
    }

    public Mono<PatientDTO> getPatient(Long id) {
        return patientRepository.findById(id)
                .flatMap(patient -> Mono.just(patientMapper.entityToDtoModel(patient)));
    }

    public Mono<ResponseEntity<Object>> createPatient(PatientDTO patientDTO) {
        return patientRepository.save(patientMapper.dtoModelToEntity(patientDTO))
                .doOnError(throwable -> log.error(throwable.getMessage()))
                .onErrorReturn(new Patient())
                .flatMap(patient -> {
                    if (patient.getId() != null)
                        return auditProducerService.audit(AuditMessageDTO.builder().resourceName(patientDTO.getFullName()).action("Create").type("Patient").build())
                                .then(Mono.just(ResponseEntity.ok(patientMapper.entityToDtoModel(patient))));
                    return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                            .errorMessage("Failed to create patient").build()));
                });
    }

    public Mono<ResponseEntity<Object>> updatePatient(Long id, PatientDTO patientDTO) {
        return patientRepository.findById(id)
                .flatMap(patient -> {
                    patientMapper.updatePatient(patientMapper.dtoModelToEntity(patientDTO), patient);
                    return patientRepository.save(patient)
                            .onErrorReturn(new Patient())
                            .flatMap(patient1 -> {
                                if (patient1.getId() != null)
                                    return auditProducerService.audit(AuditMessageDTO.builder().resourceName(patientDTO.getFullName()).action("Update").type("Patient").build())
                                            .then(Mono.just(ResponseEntity.ok(patientMapper.entityToDtoModel(patient1))));
                                return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                        .errorMessage("Failed to update patient").build()));
                            });
                });
    }

    public Mono<ResponseEntity<Boolean>> deletePatient(Long id) {
        return patientRepository.deleteById(id)
                .then(auditProducerService.audit(AuditMessageDTO.builder().resourceName(id.toString()).action("Delete").type("Patient").build())
                        .map(unused1 -> ResponseEntity.ok(true)))
                .onErrorResume(throwable -> {
                    throw new ChildFoundException();
                });
    }
}