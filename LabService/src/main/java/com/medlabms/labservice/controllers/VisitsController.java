package com.medlabms.labservice.controllers;

import com.medlabms.labservice.models.dtos.VisitDTO;
import com.medlabms.labservice.services.VisitService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;

@RestController
@RequestMapping("visits")
public class VisitsController {

    private final VisitService visitService;

    public VisitsController(VisitService visitService) {
        this.visitService = visitService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_visits:read')"))
    public ResponseEntity<Object> getAllVisits(@RequestParam(required = false) Integer page,
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
            var list = visitService.getAllVisits(pageRequest, filterBy, search);
            return ResponseEntity.ok(list);
        }
        var list = visitService.getAllVisits();
        return ResponseEntity.ok(list);
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:read')")
    public ResponseEntity<VisitDTO> getVisit(@PathVariable String id) {
        var visitDTO = visitService.getVisit(id);
        return Objects.nonNull(visitDTO) ? ResponseEntity.ok(visitDTO) : ResponseEntity.noContent().build();
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public ResponseEntity<Object> createVisit(@RequestBody VisitDTO visitDTO) {
        return visitService.createVisit(visitDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public ResponseEntity<Object> updateVisit(@PathVariable Long id, @RequestBody VisitDTO visitDTO) {
        return visitService.updateVisit(id, visitDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public ResponseEntity<Boolean> deleteVisit(@PathVariable Long id) {
        return visitService.deleteVisit(id);
    }

}