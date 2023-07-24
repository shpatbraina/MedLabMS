package com.medlabms.services;

import com.medlabms.helpers.AuditDescription;
import com.medlabms.models.entities.Audit;
import com.medlabms.repositories.AuditRepository;
import io.micronaut.data.model.Page;
import io.micronaut.data.model.Pageable;
import io.micronaut.data.model.Sort;
import jakarta.inject.Singleton;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Objects;

@Singleton
public class AuditService {

    private final AuditRepository auditRepository;

    public AuditService(AuditRepository auditRepository) {
        this.auditRepository = auditRepository;
    }

    public Mono<Page<Audit>> findAll() {
        Pageable pageable = Pageable.from(0, Integer.MAX_VALUE, Sort.of(Sort.Order.asc("id")));
        return auditRepository.findAll(pageable);
    }

    public Mono<Page<Audit>> findAll(Pageable pageable, String filterBy, String search) {
        return findBy(pageable, filterBy, search)
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(Page.of(objects.getT1(), pageable, objects.getT2())));
    }

    private Flux<Audit> findBy(Pageable pageable, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "action" -> auditRepository.findByActionContainsIgnoreCase(search, pageable);
                case "type" -> auditRepository.findByTypeContainsIgnoreCase(search, pageable);
                case "modifiedBy" -> auditRepository.findByModifiedByContainsIgnoreCase(search, pageable);
                default -> auditRepository.find(pageable);
            };
        }
        return auditRepository.find(pageable);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "action" -> auditRepository.countByActionContainsIgnoreCase(search);
                case "type" -> auditRepository.countByTypeContainsIgnoreCase(search);
                case "modifiedBy" -> auditRepository.countByModifiedByContainsIgnoreCase(search);
                default -> auditRepository.count();
            };
        }
        return auditRepository.count();
    }

    public Mono<Audit> saveAudit(Audit audit) {
        AuditDescription.setDescription(audit);
        return auditRepository.save(audit);
    }
}
