package com.medlabms.labservice.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("patients")
public class PatientsController {

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_patients:read')"))
    public Mono<ResponseEntity<Object>> getAllPatients() {
        return Mono.just(ResponseEntity.ok("TEST"));
    }
}