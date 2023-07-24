package com.medlabms.identityservice.services;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.identityservice.models.dtos.GroupDTO;
import com.medlabms.identityservice.models.entities.Group;
import com.medlabms.identityservice.repositories.GroupRepository;
import com.medlabms.identityservice.services.mappers.GroupMapper;
import com.medlabms.identityservice.services.mappers.RoleMapper;
import lombok.extern.slf4j.Slf4j;
import org.keycloak.representations.idm.GroupRepresentation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Service
public class GroupService {

    private KeycloakGroupService keycloakGroupService;
    private AuditProducerService auditProducerService;
    private GroupRepository groupRepository;
    private GroupMapper groupMapper;
    private RoleMapper roleMapper;

    public GroupService(KeycloakGroupService keycloakGroupService, AuditProducerService auditProducerService, GroupRepository groupRepository, GroupMapper groupMapper, RoleMapper roleMapper) {
        this.keycloakGroupService = keycloakGroupService;
        this.auditProducerService = auditProducerService;
        this.groupRepository = groupRepository;
        this.groupMapper = groupMapper;
        this.roleMapper = roleMapper;
    }

    public Mono<Page<Group>> getAllGroups(PageRequest pageRequest, String filterBy, String search) {

        return findBy(pageRequest, filterBy, search)
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    private Flux<Group> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
                return groupRepository.findByNameContainingIgnoreCase(search, pageRequest);
        }
        return groupRepository.findAllBy(pageRequest);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
            return groupRepository.countByNameContainingIgnoreCase(search);
        }
        return groupRepository.count();
    }

    public Mono<List<Group>> getAllGroups() {
        return groupRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE).withSort(Sort.Direction.ASC, "id")).collectList();
    }

    public Mono<GroupDTO> getGroup(String id) {
        return keycloakGroupService.getGroup(id)
                .flatMap(groupRepresentation -> groupRepository.findByKcId(groupRepresentation.getId())
                        .flatMap(group -> Mono.just(groupMapper.entityToDtoModel(group))));
    }

    public Mono<GroupDTO> getGroup(Long id) {
        return groupRepository.findById(id)
                .flatMap(group -> Mono.just(groupMapper.entityToDtoModel(group)));
    }

    public Mono<ResponseEntity<Object>> createGroup(GroupDTO groupDTO) {
        GroupRepresentation groupRepresentation = groupMapper.dtoModelToKCEntity(groupDTO);
        return keycloakGroupService.createGroup(groupRepresentation)
                .flatMap(response -> {
                    if (HttpStatus.valueOf(response.getStatus()).is2xxSuccessful()) {
                        return keycloakGroupService.searchGroup(groupDTO.getName())
                                .zipWhen(groupRepresentation1 -> groupRepository
                                        .save(groupMapper.kcEntityToEntity(groupRepresentation1))
                                        .doOnError(throwable -> log.error(throwable.getMessage())))
                                .flatMap(objects ->
                                    auditProducerService.audit(AuditMessageDTO.builder().resourceName(groupDTO.getName()).action("Create").type("Group").build())
                                            .then(Mono.just(ResponseEntity.ok(groupMapper.entityToDtoModel(objects.getT2())))));
                    } else {
                        return Mono.just(ResponseEntity.badRequest().body(response.readEntity(String.class)));
                    }
                });

    }

    public Mono<ResponseEntity<Object>> updateGroup(Long id, GroupDTO groupDTO) {
        GroupRepresentation groupRepresentation = groupMapper.dtoModelToKCEntity(groupDTO);
        return groupRepository.findById(id)
                .flatMap(group -> keycloakGroupService.updateGroup(group.getKcId(), groupRepresentation)
                        .flatMap(response -> {
                            if (HttpStatus.valueOf(response.getStatus()).is2xxSuccessful()) {
                                Group group1 = groupMapper.kcEntityToEntity(response.readEntity(GroupRepresentation.class));
                                group1.setId(group.getId());
                                groupMapper.updateGroup(group1, group);
                                return groupRepository.save(group)
                                        .flatMap(group2 -> auditProducerService.audit(AuditMessageDTO.builder().resourceName(groupDTO.getName()).action("Update").type("Group").build())
                                                .then(Mono.just(ResponseEntity.ok(groupMapper.entityToDtoModel(group2)))));
                            } else {
                                return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(response.getEntity().toString()).build()));
                            }
                        }));
    }

    public Mono<ResponseEntity<Object>> deleteGroup(Long id) {
        return groupRepository.findById(id).flatMap(group ->
                Mono.defer(() -> groupRepository.delete(group))
                        .onErrorResume(throwable -> {
                            throw new ChildFoundException();
                        })
                        .then(Mono.defer(() ->
                                keycloakGroupService.deleteGroup(group.getKcId())
                                        .flatMap(aBoolean -> {
                                            if (aBoolean) {
                                                return auditProducerService.audit(AuditMessageDTO.builder().resourceName(group.getName()).action("Delete").type("Group").build())
                                                        .then(Mono.just(ResponseEntity.ok(aBoolean)));
                                            } else {
                                                return Mono.just(ResponseEntity.badRequest().build());
                                            }
                                        }))));
    }

    public Mono<ResponseEntity<Object>> getAllAvailableRoles(Long id) {
        try {
            return groupRepository.findById(id)
                    .flatMap(group -> keycloakGroupService.getAllAvailableRoles(group.getKcId())
                            .collectList()
                            .flatMap(roleRepresentations -> Mono.just(ResponseEntity.ok(roleRepresentations
                                    .stream()
                                    .map(roleMapper::entityToModel)
                                    .collect(Collectors.toList())
                            ))));
        } catch (Exception e) {
            log.error("Error while trying to get roles: {0} " + e.getMessage());
            return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(e.getMessage()).build()));
        }
    }

    public Mono<ResponseEntity<Object>> getAllEffectiveRoles(Long id) {
        try {
            return groupRepository.findById(id)
                    .flatMap(group -> keycloakGroupService.getAllEffectiveRoles(group.getKcId())
                            .collectList()
                            .flatMap(roleRepresentations -> Mono.just(ResponseEntity.ok(roleRepresentations
                                    .stream()
                                    .map(roleMapper::entityToModel)
                                    .collect(Collectors.toList())
                            ))));
        } catch (Exception e) {
            log.error("Error while trying to get roles: {0} " + e.getMessage());
            return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(e.getMessage()).build()));
        }
    }

    public Mono<ResponseEntity<Object>> updateEffectiveRoles(Long id, List<String> roles) {
        try {
            return groupRepository.findById(id)
                    .flatMap(group -> keycloakGroupService.updateEffectiveRoles(group.getKcId(), roles)
                            .collectList()
                            .flatMap(roleRepresentations -> Mono.just(ResponseEntity.ok(roleRepresentations
                                    .stream()
                                    .map(roleMapper::entityToModel)
                                    .collect(Collectors.toList())))));
        } catch (Exception e) {
            log.error("Error while trying to update roles: {0} " + e.getMessage());
            return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(e.getMessage()).build()));
        }
    }
}
