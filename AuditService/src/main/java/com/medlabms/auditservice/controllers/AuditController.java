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

import java.util.Objects;

@RestController
@RequestMapping("/audits")
public class AuditController {

    private final AuditService auditService;

    public AuditController(AuditService auditService) {
        this.auditService = auditService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_audits:read')"))
    public ResponseEntity<Object> audits(@RequestParam(required = false) Integer page,
                                         @RequestParam(required = false) Integer size,
                                         @RequestParam(required = false) String sortBy,
                                         @RequestParam(required = false) Boolean sortDesc,
                                         @RequestParam(required = false) String filterBy,
                                         @RequestParam(required = false) String search) {
        if(page != null && size != null) {
            var pageRequest = PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "id"));
            if (Objects.nonNull(sortBy) && !sortBy.isBlank() && Objects.nonNull(sortDesc)) {
                Sort.Direction sortDirection = sortDesc ? Sort.Direction.DESC : Sort.Direction.ASC;
                pageRequest = pageRequest.withSort(sortDirection, sortBy);
            }
            var audits = auditService.findAll(pageRequest, filterBy, search);
            return ResponseEntity.ok(audits);
        }
        return ResponseEntity.ok(auditService.findAll());
    }
}

