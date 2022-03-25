package com.medlabms.labservice.services;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.labservice.models.dtos.AnalysesGroupDTO;
import com.medlabms.labservice.models.entities.AnalysesGroup;
import com.medlabms.labservice.repositories.AnalysesGroupRepository;
import com.medlabms.labservice.services.mappers.AnalysesGroupMapper;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@Service
public class AnalysesGroupService {

    private AnalysesGroupRepository analysesGroupRepository;
    private AnalysesGroupMapper analysesGroupMapper;

    public AnalysesGroupService(AnalysesGroupRepository analysesGroupRepository, AnalysesGroupMapper analysesGroupMapper) {
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

    public Mono<Page<AnalysesGroupDTO>> getAllAnalysesGroups(PageRequest pageRequest) {
        return analysesGroupRepository.findAllBy(pageRequest)
                .flatMap(analysesGroup -> Mono.just(analysesGroupMapper.entityToDtoModel(analysesGroup)))
                .collectList()
                .zipWith(analysesGroupRepository.count())
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
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
                        return Mono.just(ResponseEntity.ok(analysesGroupMapper.entityToDtoModel(analysesGroup)));
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
                                    return Mono.just(ResponseEntity.ok(analysesGroupMapper.entityToDtoModel(analysesGroup1)));
                                return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                        .errorMessage("Failed to update analyses group").build()));
                            });
                });
    }

    public Mono<ResponseEntity<Boolean>> deleteAnalysesGroup(Long id) {
        return analysesGroupRepository.deleteById(id)
                .flatMap(unused -> Mono.just(ResponseEntity.ok(true)))
                .onErrorResume(throwable -> {
                    throw new ChildFoundException();
                });
    }
}