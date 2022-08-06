package com.medlabms.labservice.controllers;

import com.medlabms.labservice.models.dtos.AnalysesGroupDTO;
import com.medlabms.labservice.services.AnalysesGroupService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

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
    public Mono<ResponseEntity<Object>> getAllAnalysesGroups(@RequestParam(required = false) Integer page,
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
            return analysesGroupService.getAllAnalysesGroups(pageRequest, filterBy, search).flatMap(analysesGroups -> Mono.just(ResponseEntity.ok(analysesGroups)));

        }
        return analysesGroupService.getAllAnalysesGroups().flatMap(groups -> Mono.just(ResponseEntity.ok(groups)));
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:read')")
    public Mono<ResponseEntity<AnalysesGroupDTO>> getAnalysesGroup(@PathVariable Long id) {
        return analysesGroupService.getAnalysesGroup(id)
                .flatMap(analysesGroupDTO -> Objects.nonNull(analysesGroupDTO) ?
                        Mono.just(ResponseEntity.ok(analysesGroupDTO)) : Mono.just(ResponseEntity.noContent().build()));
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:save')")
    public Mono<ResponseEntity<Object>> createAnalysesGroup(@RequestBody AnalysesGroupDTO analysesGroupDTO) {
        return analysesGroupService.createAnalysesGroup(analysesGroupDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:save')")
    public Mono<ResponseEntity<Object>> updateAnalysesGroup(@PathVariable Long id, @RequestBody AnalysesGroupDTO analysesGroupDTO) {
        return analysesGroupService.updateAnalysesGroup(id, analysesGroupDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analysesGroups:save')")
    public Mono<ResponseEntity<Boolean>> deleteAnalysesGroup(@PathVariable Long id) {
        return analysesGroupService.deleteAnalysesGroup(id);
    }

}