package com.medlabms.identityservice.controllers;

import com.medlabms.identityservice.models.dtos.GroupDTO;
import com.medlabms.identityservice.models.dtos.RoleDTO;
import com.medlabms.identityservice.services.GroupService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/groups")
public class GroupController {

    private final GroupService groupService;

    public GroupController(GroupService groupService) {
        this.groupService = groupService;
    }

    @GetMapping(value = "", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public ResponseEntity<Object> getAllGroups(@RequestParam(required = false) Integer page,
                                                     @RequestParam(required = false) Integer size,
                                                     @RequestParam(required = false) String sortBy,
                                                     @RequestParam(required = false) Boolean sortDesc,
                                                     @RequestParam(required = false) String filterBy,
                                                     @RequestParam(required = false) String search) {
        if(page != null && size != null) {
            PageRequest pageRequest = PageRequest.of(page, size);
            if (Objects.nonNull(sortBy) && !sortBy.isBlank() && Objects.nonNull(sortDesc)) {
                Sort.Direction sortDirection = sortDesc ? Sort.Direction.DESC : Sort.Direction.ASC;
                pageRequest = pageRequest.withSort(sortDirection, sortBy);
            }
            return ResponseEntity.ok(groupService.getAllGroups(pageRequest, filterBy, search));
        }
        return ResponseEntity.ok(groupService.getAllGroups());
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public ResponseEntity<GroupDTO> getGroup(@PathVariable String id) {
        var groupDTO = groupService.getGroup(id);
        return Objects.nonNull(groupDTO) ? ResponseEntity.ok(groupDTO) : ResponseEntity.noContent().build();
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public ResponseEntity<Object> createGroup(@RequestBody GroupDTO groupDTO) {
        return groupService.createGroup(groupDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public ResponseEntity<Object> updateGroup(@PathVariable Long id, @RequestBody GroupDTO groupDTO) {
        return groupService.updateGroup(id, groupDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public ResponseEntity<Object> deleteGroup(@PathVariable Long id) {
        return groupService.deleteGroup(id);
    }

    @GetMapping(value = "/availableRoles/{groupId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public ResponseEntity<Object> getAllAvailableRoles(@PathVariable Long groupId) {
        return groupService.getAllAvailableRoles(groupId);
    }

    @GetMapping(value = "/effectiveRoles/{groupId}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:read')")
    public ResponseEntity<Object> getAllEffectiveRoles(@PathVariable Long groupId) {
        return groupService.getAllEffectiveRoles(groupId);
    }

    @PutMapping(value = "/roles/{groupId}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_groups:save')")
    public ResponseEntity<Object> updateRole(@PathVariable Long groupId, @RequestBody List<RoleDTO> roleDTOS) {
        return groupService.updateEffectiveRoles(groupId, roleDTOS.stream().map((RoleDTO::getName)).collect(Collectors.toList()));
    }

}
