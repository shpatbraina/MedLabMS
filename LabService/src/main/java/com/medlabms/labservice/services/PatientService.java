package com.medlabms.labservice.services;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.PatientDTO;
import com.medlabms.labservice.models.entities.Patient;
import com.medlabms.labservice.repositories.PatientRepository;
import com.medlabms.labservice.services.mappers.PatientMapper;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@Service
public class PatientService {

    private PatientRepository patientRepository;
    private PatientMapper patientMapper;

    public PatientService(PatientRepository patientRepository, PatientMapper patientMapper) {
        this.patientRepository = patientRepository;
        this.patientMapper = patientMapper;
    }

    public Mono<Page<PatientDTO>> getAllPatients(PageRequest pageRequest) {
        return patientRepository.findAllBy(pageRequest)
                .flatMap(patient -> Mono.just(patientMapper.entityToDtoModel(patient)))
                .collectList()
                .zipWith(patientRepository.count())
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    public Mono<PatientDTO> getPatient(String id) {
        return patientRepository.findById(Long.parseLong(id))
                .flatMap(patient -> Mono.just(patientMapper.entityToDtoModel(patient)));
    }

    public Mono<ResponseEntity<Object>> createPatient(PatientDTO patientDTO) {
        return patientRepository.save(patientMapper.dtoModelToEntity(patientDTO))
                .doOnError(throwable -> log.error(throwable.getMessage()))
                .onErrorReturn(new Patient())
                .flatMap(patient -> {
                    if (patient.getId() != null)
                        return Mono.just(ResponseEntity.ok(patientMapper.entityToDtoModel(patient)));
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
                                    return Mono.just(ResponseEntity.ok(patientMapper.entityToDtoModel(patient1)));
                                return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                        .errorMessage("Failed to update patient").build()));
                            });
                });
    }

    public Mono<ResponseEntity<Boolean>> deletePatient(Long id) {
        return patientRepository.deleteById(id)
                .flatMap(unused -> Mono.just(ResponseEntity.ok(true)))
                .onErrorReturn(ResponseEntity.badRequest().body(false));
    }
}