package com.medlabms.auditservice.services;

import com.medlabms.auditservice.models.dtos.AuditDTO;
import com.medlabms.auditservice.models.entities.Audit;
import com.medlabms.auditservice.repositories.AuditRepository;
import com.medlabms.auditservice.services.mappers.AuditMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AuditService {

    private final AuditRepository auditRepository;
    private final AuditMapper auditMapper;

    public AuditService(AuditRepository auditRepository, AuditMapper auditMapper) {
        this.auditRepository = auditRepository;
        this.auditMapper = auditMapper;
    }

    public Mono<List<AuditDTO>> getAllAudits() {
        return auditRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .collectList()
                .flatMap(audits -> Mono.just(audits.stream()
                        .map(auditMapper::entityToDtoModel).collect(Collectors.toList())));
    }

    public Mono<Page<AuditDTO>> getAllAudits(PageRequest pageRequest, String filterBy, String search) {
        return findBy(pageRequest, filterBy, search)
                .flatMap(audit -> Mono.just(auditMapper.entityToDtoModel(audit)))
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    private Flux<Audit> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "type" -> auditRepository.findByTypeContainingIgnoreCase(search, pageRequest);
                case "action" -> auditRepository.findByActionContainingIgnoreCase(search, pageRequest);
                case "modifiedBy" -> auditRepository.findByModifiedByContainingIgnoreCase(search, pageRequest);
//                case "date" -> auditRepository.findByDateContainingIgnoreCase(search, pageRequest);
                default -> auditRepository.findAllBy(pageRequest);
            };
        }
        return auditRepository.findAllBy(pageRequest);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "type" -> auditRepository.countByTypeContainingIgnoreCase(search);
                case "action" -> auditRepository.countByActionContainingIgnoreCase(search);
                case "modifiedBy" -> auditRepository.countByModifiedByContainingIgnoreCase(search);
//                case "date" -> auditRepository.countByDateContainingIgnoreCase(search);
                default -> auditRepository.count();
            };
        }
        return auditRepository.count();
    }

}
