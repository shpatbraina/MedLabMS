package com.medlabms.identityservice.controllers;

import com.medlabms.identityservice.models.dtos.GroupDTO;
import com.medlabms.identityservice.models.dtos.RoleDTO;
import com.medlabms.identityservice.services.GroupService;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/groups")
public class GroupController {

    private GroupService groupService;

    public GroupController(GroupService groupService) {
        this.groupService = groupService;
    }

    @GetMapping(value = "", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public Mono<ResponseEntity<Object>> getAllGroups(@RequestParam(required = false) Integer page, @RequestParam(required = false) Integer size) {
        if(page != null && size != null)
            return groupService.getAllGroups(PageRequest.of(page,size)).flatMap(groups -> Mono.just(ResponseEntity.ok(groups)));
        return groupService.getAllGroups().flatMap(groups -> Mono.just(ResponseEntity.ok(groups)));
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public Mono<ResponseEntity<GroupDTO>> getGroup(@PathVariable String id) {
        return groupService.getGroup(id)
                .flatMap(groupDTO -> Objects.nonNull(groupDTO) ?
                        Mono.just(ResponseEntity.ok(groupDTO)) : Mono.just(ResponseEntity.noContent().build()));
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public Mono<ResponseEntity<Object>> createGroup(@RequestBody GroupDTO groupDTO) {
        return groupService.createGroup(groupDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public Mono<ResponseEntity<Object>> updateGroup(@PathVariable Long id, @RequestBody GroupDTO groupDTO) {
        return groupService.updateGroup(id, groupDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public Mono<ResponseEntity<Object>> deleteGroup(@PathVariable Long id) {
        return groupService.deleteGroup(id);
    }

    @GetMapping(value = "/availableRoles/{groupId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public Mono<ResponseEntity<Object>> getAllAvailableRoles(@PathVariable Long groupId) {
        return groupService.getAllAvailableRoles(groupId);
    }

    @GetMapping(value = "/effectiveRoles/{groupId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public Mono<ResponseEntity<Object>> getAllEffectiveRoles(@PathVariable Long groupId) {
        return groupService.getAllEffectiveRoles(groupId);
    }

    @PutMapping(value = "/roles/{groupId}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public Mono<ResponseEntity<Object>> updateRole(@PathVariable Long groupId, @RequestBody List<RoleDTO> roleDTOS) {
        return groupService.updateEffectiveRoles(groupId, roleDTOS.stream().map((RoleDTO::getName)).collect(Collectors.toList()));
    }

}
