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

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AnalysesGroupService {

    private final AuditProducerService auditProducerService;
    private final AnalysesGroupRepository analysesGroupRepository;
    private final AnalysesGroupMapper analysesGroupMapper;

    public AnalysesGroupService(AuditProducerService auditProducerService, AnalysesGroupRepository analysesGroupRepository, AnalysesGroupMapper analysesGroupMapper) {
        this.auditProducerService = auditProducerService;
        this.analysesGroupRepository = analysesGroupRepository;
        this.analysesGroupMapper = analysesGroupMapper;
    }

    public List<AnalysesGroupDTO> getAllAnalysesGroups() {
        return analysesGroupRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                        .withSort(Sort.Direction.ASC, "id"))
                .stream().map(analysesGroupMapper::entityToDtoModel).collect(Collectors.toList());
    }

    public Page<AnalysesGroupDTO> getAllAnalysesGroups(PageRequest pageRequest, String filterBy, String search) {
        var list = findBy(pageRequest, filterBy, search)
                .stream().map(analysesGroupMapper::entityToDtoModel)
                .toList();
        return new PageImpl<>(list, pageRequest, countBy(filterBy, search));
    }

    private List<AnalysesGroup> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
            return analysesGroupRepository.findByNameContainingIgnoreCase(search, pageRequest);
        }
        return analysesGroupRepository.findAllBy(pageRequest);
    }

    private Long countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
            return analysesGroupRepository.countByNameContainingIgnoreCase(search);
        }
        return analysesGroupRepository.count();
    }

    public AnalysesGroupDTO getAnalysesGroup(Long id) {
        var analysesGroup = analysesGroupRepository.findById(id).orElseThrow();
        return analysesGroupMapper.entityToDtoModel(analysesGroup);
    }

    public ResponseEntity<Object> createAnalysesGroup(AnalysesGroupDTO analysesGroupDTO) {
        try {
            var analysesGroup = analysesGroupRepository.save(analysesGroupMapper.dtoModelToEntity(analysesGroupDTO));
            auditProducerService.audit(AuditMessageDTO.builder()
                    .resourceName(analysesGroupDTO.getName())
                    .action("Create")
                    .type("AnalysesGroup")
                    .build());
            return ResponseEntity.ok(analysesGroupMapper.entityToDtoModel(analysesGroup));
        }catch (Exception e){
            log.error(e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder()
                    .errorMessage("Failed to create analyses group").build());
        }
    }

    public ResponseEntity<Object> updateAnalysesGroup(Long id, AnalysesGroupDTO analysesGroupDTO) {
        try {
            var analysesGroup = analysesGroupRepository.findById(id).orElseThrow();
            analysesGroupMapper.updateAnalysesGroup(analysesGroupMapper.dtoModelToEntity(analysesGroupDTO), analysesGroup);
            analysesGroup = analysesGroupRepository.save(analysesGroup);
            auditProducerService.audit(AuditMessageDTO.builder()
                            .resourceName(analysesGroupDTO.getName())
                            .action("Update")
                            .type("AnalysesGroup")
                            .build());
            return ResponseEntity.ok(analysesGroupMapper.entityToDtoModel(analysesGroup));
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder()
                    .errorMessage("Failed to update analyses group")
                    .build());
        }
    }

    public ResponseEntity<Boolean> deleteAnalysesGroup(Long id) {
        try {
            analysesGroupRepository.deleteById(id);
            auditProducerService.audit(AuditMessageDTO.builder()
                    .resourceName(id.toString())
                    .action("Delete")
                    .type("AnalysesGroup")
                    .build());
            return ResponseEntity.ok(true);
        } catch (Exception e) {
            log.error(e.getMessage());
            throw new ChildFoundException();
        }
    }
}