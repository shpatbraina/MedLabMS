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

    public List<PatientDTO> getAllPatients() {
        return patientRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .stream()
                        .map(patientMapper::entityToDtoModel).collect(Collectors.toList());
    }

    public Page<PatientDTO> getAllPatients(PageRequest pageRequest, String filterBy, String search) {
        var list = findBy(pageRequest, filterBy, search)
                .stream().map(patient -> patientMapper.entityToDtoModel(patient))
                .collect(Collectors.toList());

        var count = countBy(filterBy, search);

        return new PageImpl<>(list, pageRequest, count);
    }

    private List<Patient> findBy(PageRequest pageRequest, String filterBy, String search) {
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

    private Long countBy(String filterBy, String search) {
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

    public PatientDTO getPatient(Long id) {
        var patient = patientRepository.findById(id);
        return patientMapper.entityToDtoModel(patient.orElseThrow());
    }

    public ResponseEntity<Object> createPatient(PatientDTO patientDTO) {
        try {
            var patient = patientRepository.save(patientMapper.dtoModelToEntity(patientDTO));
            auditProducerService.audit(AuditMessageDTO.builder().resourceName(patientDTO.getFullName()).action("Create").type("Patient").build());
            return ResponseEntity.ok(patientMapper.entityToDtoModel(patient));
        }catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage("Failed to create patient").build());
        }
    }

    public ResponseEntity<Object> updatePatient(Long id, PatientDTO patientDTO) {
        var patient = patientRepository.findById(id);
        patientMapper.updatePatient(patientMapper.dtoModelToEntity(patientDTO), patient.orElseThrow());
        var updated = patientRepository.save(patient.orElseThrow());
        if (Objects.nonNull(updated.getId())) {
            auditProducerService.audit(AuditMessageDTO.builder().resourceName(patientDTO.getFullName()).action("Update").type("Patient").build());
            return ResponseEntity.ok(patientMapper.entityToDtoModel(updated));
        }
        return ResponseEntity.badRequest().body(ErrorDTO.builder()
                .errorMessage("Failed to update patient").build());
    }

    public ResponseEntity<Boolean> deletePatient(Long id) {
        try {
            patientRepository.deleteById(id);
            auditProducerService.audit(AuditMessageDTO.builder().resourceName(id.toString()).action("Delete").type("Patient").build());
            return ResponseEntity.ok(true);
        }catch (Exception e){
            throw new ChildFoundException();
        }
    }
}