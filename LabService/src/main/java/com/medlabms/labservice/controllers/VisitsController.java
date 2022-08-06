package com.medlabms.labservice.controllers;

import com.medlabms.labservice.models.dtos.VisitDTO;
import com.medlabms.labservice.services.VisitService;
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
@RequestMapping("visits")
public class VisitsController
{

    private VisitService visitService;

    public VisitsController(VisitService visitService) {
        this.visitService = visitService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_visits:read')"))
    public Mono<ResponseEntity<Object>> getAllVisits(@RequestParam(required = false) Integer page,
                                                     @RequestParam(required = false) Integer size,
                                                     @RequestParam(required = false) String sortBy,
                                                     @RequestParam(required = false) Boolean sortDesc,
                                                     @RequestParam(required = false) String filterBy,
                                                     @RequestParam(required = false) String search) {
        if(page != null && size != null) {
            var pageRequest = PageRequest.of(page,size);
            if (Objects.nonNull(sortBy) && !sortBy.isBlank() && Objects.nonNull(sortDesc)) {
                Sort.Direction sortDirection = sortDesc ? Sort.Direction.DESC : Sort.Direction.ASC;
                pageRequest = pageRequest.withSort(sortDirection, sortBy);
            }
            return visitService.getAllVisits(pageRequest, filterBy, search).flatMap(visits -> Mono.just(ResponseEntity.ok(visits)));
        }
        return visitService.getAllVisits().flatMap(visitDTOS -> Mono.just(ResponseEntity.ok(visitDTOS)));
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:read')")
    public Mono<ResponseEntity<VisitDTO>> getVisit(@PathVariable String id) {
        return visitService.getVisit(id)
                .flatMap(visitDTO -> Objects.nonNull(visitDTO) ?
                        Mono.just(ResponseEntity.ok(visitDTO)) : Mono.just(ResponseEntity.noContent().build()));
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public Mono<ResponseEntity<Object>> createVisit(@RequestBody VisitDTO visitDTO) {
        return visitService.createVisit(visitDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public Mono<ResponseEntity<Object>> updateVisit(@PathVariable Long id, @RequestBody VisitDTO visitDTO) {
        return visitService.updateVisit(id, visitDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public Mono<ResponseEntity<Boolean>> deleteVisit(@PathVariable Long id) {
        return visitService.deleteVisit(id);
    }

}