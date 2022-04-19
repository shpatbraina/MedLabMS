package com.medlabms.labservice.controllers;

import java.util.Objects;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.medlabms.labservice.models.dtos.PatientDTO;
import com.medlabms.labservice.services.PatientService;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("patients")
public class PatientsController {

    private PatientService patientService;

    public PatientsController(PatientService patientService) {
        this.patientService = patientService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_patients:read')"))
    public Mono<ResponseEntity<Object>> getAllPatients(@RequestParam(required = false) Integer page, @RequestParam(required = false) Integer size) {
        if(page != null && size != null)
            return patientService.getAllPatients(PageRequest.of(page,size).withSort(Sort.Direction.ASC, "id")).flatMap(patients -> Mono.just(ResponseEntity.ok(patients)));
        return patientService.getAllPatients().flatMap(patients -> Mono.just(ResponseEntity.ok(patients)));
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_patients:read')")
    public Mono<ResponseEntity<PatientDTO>> getPatient(@PathVariable String id) {
        return patientService.getPatient(Long.parseLong(id))
                .flatMap(patientDTO -> Objects.nonNull(patientDTO) ?
                        Mono.just(ResponseEntity.ok(patientDTO)) : Mono.just(ResponseEntity.noContent().build()));
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_patients:save')")
    public Mono<ResponseEntity<Object>> createPatient(@RequestBody PatientDTO patientDTO) {
        return patientService.createPatient(patientDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_patients:save')")
    public Mono<ResponseEntity<Object>> updatePatient(@PathVariable Long id, @RequestBody PatientDTO patientDTO) {
        return patientService.updatePatient(id, patientDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_patients:save')")
    public Mono<ResponseEntity<Boolean>> deletePatient(@PathVariable Long id) {
        return patientService.deletePatient(id);
    }

}