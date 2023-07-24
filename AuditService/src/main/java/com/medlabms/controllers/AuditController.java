package com.medlabms.controllers;

import com.medlabms.services.AuditService;
import io.micronaut.core.annotation.Nullable;
import io.micronaut.data.model.Pageable;
import io.micronaut.data.model.Sort;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import io.micronaut.security.annotation.Secured;
import reactor.core.publisher.Mono;

import java.util.Objects;
import java.util.Optional;

@Controller("/audits")
public class AuditController {

    private final AuditService auditService;

    public AuditController(AuditService auditService) {
        this.auditService = auditService;
    }

    @Get
    @Secured({"audits:read"})
    public Mono<HttpResponse<Object>> audits(@Nullable @QueryValue Integer page,
                                             @Nullable @QueryValue Integer size,
                                             @Nullable @QueryValue String sortBy,
                                             @Nullable @QueryValue Boolean sortDesc,
                                             @Nullable @QueryValue String filterBy,
                                             @Nullable @QueryValue String search) {
        if(page != null && size != null) {
            Pageable pageable = Pageable.from(page, size, Sort.of(Sort.Order.asc("id")));
            if (Objects.nonNull(sortBy) && !sortBy.isBlank() && Objects.nonNull(sortDesc)) {
                Sort.Order order = sortDesc ? Sort.Order.desc(sortBy) : Sort.Order.asc(sortBy);
                Sort sort = Sort.of(order);
                pageable = Pageable.from(page, size, sort);
            }
            return auditService.findAll(pageable, filterBy, search).flatMap(audits -> Mono.just(HttpResponse.ok(audits)));
        }
        return auditService.findAll().flatMap(audits -> Mono.just(HttpResponse.ok(audits)));
    }
}
