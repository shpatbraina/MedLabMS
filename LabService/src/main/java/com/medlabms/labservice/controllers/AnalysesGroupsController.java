package com.medlabms.labservice.controllers;

import com.medlabms.labservice.models.dtos.AnalysesGroupDTO;
import com.medlabms.labservice.services.AnalysesGroupService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;

@RestController
@RequestMapping("analysesGroups")
public class AnalysesGroupsController {

    private AnalysesGroupService analysesGroupService;

    public AnalysesGroupsController(AnalysesGroupService analysesGroupService) {
        this.analysesGroupService = analysesGroupService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_analysesGroups:read')"))
    public ResponseEntity<Object> getAllAnalysesGroups(@RequestParam(required = false) Integer page,
                                                             @RequestParam(required = false) Integer size,
                                                             @RequestParam(required = false) String sortBy,
                                                             @RequestParam(required = false) Boolean sortDesc,
                                                             @RequestParam(required = false) String filterBy,
                                                             @RequestParam(required = false) String search) {
        if(page != null && size != null) {
            var pageRequest = PageRequest.of(page, size);
            if (Objects.nonNull(sortBy) && !sortBy.isBlank() && Objects.nonNull(sortDesc)) {
                Sort.Direction sortDirection = sortDesc ? Sort.Direction.DESC : Sort.Direction.ASC;
                pageRequest = pageRequest.withSort(sortDirection, sortBy);
            }
            var analysesGroups = analysesGroupService.getAllAnalysesGroups(pageRequest, filterBy, search);
            return ResponseEntity.ok(analysesGroups);

        }
        var analysesGroups = analysesGroupService.getAllAnalysesGroups();
        return ResponseEntity.ok(analysesGroups);
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:read')")
    public ResponseEntity<AnalysesGroupDTO> getAnalysesGroup(@PathVariable Long id) {
        var analysesGroupDTO = analysesGroupService.getAnalysesGroup(id);
        return Objects.nonNull(analysesGroupDTO) ? ResponseEntity.ok(analysesGroupDTO) : ResponseEntity.noContent().build();
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:save')")
    public ResponseEntity<Object> createAnalysesGroup(@RequestBody AnalysesGroupDTO analysesGroupDTO) {
        return analysesGroupService.createAnalysesGroup(analysesGroupDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:save')")
    public ResponseEntity<Object> updateAnalysesGroup(@PathVariable Long id, @RequestBody AnalysesGroupDTO analysesGroupDTO) {
        return analysesGroupService.updateAnalysesGroup(id, analysesGroupDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:save')")
    public ResponseEntity<Boolean> deleteAnalysesGroup(@PathVariable Long id) {
        return analysesGroupService.deleteAnalysesGroup(id);
    }

}