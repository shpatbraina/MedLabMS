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

    public Page<Group> getAllGroups(PageRequest pageRequest, String filterBy, String search) {

        var list = findBy(pageRequest, filterBy, search);
        var total = countBy(filterBy, search);
        return new PageImpl<>(list, pageRequest, total);
    }

    private List<Group> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
                return groupRepository.findByNameContainingIgnoreCase(search, pageRequest);
        }
        return groupRepository.findAllBy(pageRequest);
    }

    private Long countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank() && "name".equals(filterBy)) {
            return groupRepository.countByNameContainingIgnoreCase(search);
        }
        return groupRepository.count();
    }

    public List<Group> getAllGroups() {
        return groupRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE)
                .withSort(Sort.Direction.ASC, "id"));
    }

    public GroupDTO getGroup(String id) {
        var group = keycloakGroupService.getGroup(id);
        var groupRepresentation = groupRepository.findByKcId(group.orElseThrow().getId());
        return groupMapper.entityToDtoModel(groupRepresentation);
    }

    public GroupDTO getGroup(Long id) {
        return groupMapper.entityToDtoModel(groupRepository.findById(id).orElseThrow());
    }

    public ResponseEntity<Object> createGroup(GroupDTO groupDTO) {
        GroupRepresentation groupRepresentation = groupMapper.dtoModelToKCEntity(groupDTO);
        Group savedGroup = null;
        var response = keycloakGroupService.createGroup(groupRepresentation);

        if (HttpStatus.valueOf(response.orElseThrow().getStatus()).is2xxSuccessful()) {
            var optionalGroupRepresentation = keycloakGroupService.searchGroup(groupDTO.getName());
            try {
                savedGroup = groupRepository
                        .save(groupMapper.kcEntityToEntity(optionalGroupRepresentation.orElseThrow()));
            }catch (Exception e) {
                log.error(e.getMessage());
            }
            auditProducerService.audit(AuditMessageDTO.builder()
                            .resourceName(groupDTO.getName()).action("Create").type("Group").build());
            return ResponseEntity.ok(groupMapper.entityToDtoModel(savedGroup));
        } else {
            return ResponseEntity.badRequest().body(response.orElseThrow().readEntity(String.class));
        }
    }

    public ResponseEntity<Object> updateGroup(Long id, GroupDTO groupDTO) {
        GroupRepresentation groupRepresentation = groupMapper.dtoModelToKCEntity(groupDTO);
        var group = groupRepository.findById(id);
        Group group2 = null;
        var response = keycloakGroupService.updateGroup(group.orElseThrow().getKcId(), groupRepresentation);
        if (HttpStatus.valueOf(response.orElseThrow().getStatus()).is2xxSuccessful()) {
            Group group1 = groupMapper.kcEntityToEntity(response.orElseThrow().readEntity(GroupRepresentation.class));
            group1.setId(group.orElseThrow().getId());
            groupMapper.updateGroup(group1, group.orElseThrow());
            group2 = groupRepository.save(group.orElseThrow());
            auditProducerService.audit(AuditMessageDTO.builder()
                            .resourceName(groupDTO.getName()).action("Update").type("Group").build());
            return ResponseEntity.ok(groupMapper.entityToDtoModel(group2));
        } else {
            return ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(response.orElseThrow()
                    .getEntity().toString()).build());
        }
    }

    public ResponseEntity<Object> deleteGroup(Long id) {
        var group = groupRepository.findById(id);
        try {
            groupRepository.deleteById(id);
        }catch (Exception e) {
            throw new ChildFoundException();
        }

        var deletedGroup = keycloakGroupService.deleteGroup(group.orElseThrow().getKcId());
        if (deletedGroup.orElseThrow()) {
            auditProducerService.audit(AuditMessageDTO.builder()
                    .resourceName(group.orElseThrow().getName()).action("Delete").type("Group").build());
            return ResponseEntity.ok(true);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    public ResponseEntity<Object> getAllAvailableRoles(Long id) {
        try {
            var group = groupRepository.findById(id);
            var list = keycloakGroupService.getAllAvailableRoles(group.orElseThrow().getKcId());
            return ResponseEntity.ok(list
                                    .stream()
                                    .map(roleMapper::entityToModel)
                                    .collect(Collectors.toList()));
        } catch (Exception e) {
            log.error("Error while trying to get roles: {0} " + e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(e.getMessage()).build());
        }
    }

    public ResponseEntity<Object> getAllEffectiveRoles(Long id) {
        try {
            var group = groupRepository.findById(id);
            var list = keycloakGroupService.getAllEffectiveRoles(group.orElseThrow().getKcId());
            return ResponseEntity.ok(list
                                    .stream()
                                    .map(roleMapper::entityToModel)
                                    .collect(Collectors.toList()));
        } catch (Exception e) {
            log.error("Error while trying to get roles: {0} " + e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(e.getMessage()).build());
        }
    }

    public ResponseEntity<Object> updateEffectiveRoles(Long id, List<String> roles) {
        try {
            var group = groupRepository.findById(id);
            var list = keycloakGroupService.updateEffectiveRoles(group.orElseThrow().getKcId(), roles);
            return ResponseEntity.ok(list
                                    .stream()
                                    .map(roleMapper::entityToModel)
                                    .collect(Collectors.toList()));
        } catch (Exception e) {
            log.error("Error while trying to update roles: {0} " + e.getMessage());
            return ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(e.getMessage()).build());
        }
    }
}
