package com.medlabms.auditservice.services;

import com.medlabms.auditservice.helpers.AuditDescription;
import com.medlabms.auditservice.models.entities.Audit;
import com.medlabms.auditservice.repositories.AuditRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class AuditService {

    private final AuditRepository auditRepository;

    public AuditService(AuditRepository auditRepository) {
        this.auditRepository = auditRepository;
    }

    public Page<Audit> findAll() {
        var list = auditRepository.findAllBy(PageRequest
                .ofSize(Integer.MAX_VALUE).withSort(Sort.Direction.ASC, "id"));

        return new PageImpl<>(list);
    }

    public Page<Audit> findAll(PageRequest pageRequest, String filterBy, String search) {
        var list = findBy(pageRequest, filterBy, search);
        if (list.isEmpty()) {
            return Page.empty(pageRequest);
        }
        return new PageImpl<>(list, pageRequest, countBy(filterBy, search));
    }

    private List<Audit> findBy(PageRequest pageable, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "action" -> auditRepository.findByActionContainsIgnoreCase(search, pageable);
                case "type" -> auditRepository.findByTypeContainsIgnoreCase(search, pageable);
                case "modifiedBy" -> auditRepository.findByModifiedByContainsIgnoreCase(search, pageable);
                default -> auditRepository.findAllBy(pageable);
            };
        }
        return auditRepository.findAllBy(pageable);
    }

    private Long countBy(String filterBy, String search) {
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

    public Audit saveAudit(Audit audit) {
        AuditDescription.setDescription(audit);
        return auditRepository.save(audit);
    }
}
