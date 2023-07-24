package com.medlabms.labservice.services;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.AnalysesGroupDTO;
import com.medlabms.labservice.models.entities.AnalysesGroup;
import com.medlabms.labservice.repositories.AnalysesGroupRepository;
import com.medlabms.labservice.services.mappers.AnalysesGroupMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AnalysesGroupService {

    private AuditProducerService auditProducerService;
    private AnalysesGroupRepository analysesGroupRepository;
    private AnalysesGroupMapper analysesGroupMapper;

    public AnalysesGroupService(AuditProducerService auditProducerService, AnalysesGroupRepository analysesGroupRepository, AnalysesGroupMapper analysesGroupMapper) {
        this.auditProducerService = auditProducerService;
        this.analysesGroupRepository = analysesGroupRepository;
        this.analysesGroupMapper = analysesGroupMapper;
    }

    public Mono<List<AnalysesGroupDTO>> getAllAnalysesGroups() {
        return analysesGroupRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .collectList()
                .flatMap(analysesGroups -> Mono.just(analysesGroups.stream()
                        .map(analysesGroupMapper::entityToDtoModel).collect(Collectors.toList())));
    }

    public Mono<Page<AnalysesGroupDTO>> getAllAnalysesGroups(PageRequest pageRequest, String filterBy, String search) {
        return findBy(pageRequest, filterBy, search)
                .flatMap(analysesGroup -> Mono.just(analysesGroupMapper.entityToDtoModel(analysesGroup)))
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    private Flux<AnalysesGroup> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
            return analysesGroupRepository.findByNameContainingIgnoreCase(search, pageRequest);
        }
        return analysesGroupRepository.findAllBy(pageRequest);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
            return analysesGroupRepository.countByNameContainingIgnoreCase(search);
        }
        return analysesGroupRepository.count();
    }

    public Mono<AnalysesGroupDTO> getAnalysesGroup(Long id) {
        return analysesGroupRepository.findById(id)
                .flatMap(analysesGroup -> Mono.just(analysesGroupMapper.entityToDtoModel(analysesGroup)));
    }

    public Mono<ResponseEntity<Object>> createAnalysesGroup(AnalysesGroupDTO analysesGroupDTO) {
        return analysesGroupRepository.save(analysesGroupMapper.dtoModelToEntity(analysesGroupDTO))
                .doOnError(throwable -> log.error(throwable.getMessage()))
                .onErrorReturn(new AnalysesGroup())
                .flatMap(analysesGroup -> {
                    if (analysesGroup.getId() != null)
                        return auditProducerService.audit(AuditMessageDTO.builder().resourceName(analysesGroupDTO.getName()).action("Create").type("AnalysesGroup").build())
                                .then(Mono.just(ResponseEntity.ok(analysesGroupMapper.entityToDtoModel(analysesGroup))));
                    return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                            .errorMessage("Failed to create analyses group").build()));
                });
    }

    public Mono<ResponseEntity<Object>> updateAnalysesGroup(Long id, AnalysesGroupDTO analysesGroupDTO) {
        return analysesGroupRepository.findById(id)
                .flatMap(analysesGroup -> {
                    analysesGroupMapper.updateAnalysesGroup(analysesGroupMapper.dtoModelToEntity(analysesGroupDTO), analysesGroup);
                    return analysesGroupRepository.save(analysesGroup)
                            .onErrorReturn(new AnalysesGroup())
                            .flatMap(analysesGroup1 -> {
                                if (analysesGroup1.getId() != null)
                                    return auditProducerService.audit(AuditMessageDTO.builder().resourceName(analysesGroupDTO.getName()).action("Update").type("AnalysesGroup").build())
                                            .then(Mono.just(ResponseEntity.ok(analysesGroupMapper.entityToDtoModel(analysesGroup1))));
                                return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                        .errorMessage("Failed to update analyses group").build()));
                            });
                });
    }

    public Mono<ResponseEntity<Boolean>> deleteAnalysesGroup(Long id) {
        return analysesGroupRepository.deleteById(id)
                .then(auditProducerService.audit(AuditMessageDTO.builder().resourceName(id.toString()).action("Delete").type("AnalysesGroup").build())
                        .map(unused -> ResponseEntity.ok(true)))
                .onErrorResume(throwable -> {
                    throw new ChildFoundException();
                });
    }
}