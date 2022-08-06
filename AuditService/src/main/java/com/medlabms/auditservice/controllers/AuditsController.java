package com.medlabms.auditservice.controllers;

import com.medlabms.auditservice.services.AuditService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.Objects;

@RestController
@RequestMapping("audits")
public class AuditsController {

    private final AuditService auditService;

    public AuditsController(AuditService auditService) {
        this.auditService = auditService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_audits:read')"))
    public Mono<ResponseEntity<Object>> getAllAudits(@RequestParam(required = false) Integer page,
                                                       @RequestParam(required = false) Integer size,
                                                       @RequestParam(required = false) String sortBy,
                                                       @RequestParam(required = false) Boolean sortDesc,
                                                       @RequestParam(required = false) String filterBy,
                                                       @RequestParam(required = false) String search) {
        if(page != null && size != null) {
            PageRequest pageRequest = PageRequest.of(page, size);
            if (Objects.nonNull(sortBy) && !sortBy.isBlank() && Objects.nonNull(sortDesc)) {
                Sort.Direction sortDirection = sortDesc ? Sort.Direction.DESC : Sort.Direction.ASC;
                pageRequest = pageRequest.withSort(sortDirection, sortBy);
            }
            return auditService.getAllAudits(pageRequest, filterBy, search).flatMap(patients -> Mono.just(ResponseEntity.ok(patients)));
        }
        return auditService.getAllAudits().flatMap(patients -> Mono.just(ResponseEntity.ok(patients)));
    }
}
