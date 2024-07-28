package com.medlabms.labservice.controllers;

import com.medlabms.labservice.models.dtos.AnalysisDTO;
import com.medlabms.labservice.services.AnalysisService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;

@RestController
@RequestMapping("analyses")
public class AnalysesController {

    private AnalysisService analysisService;

    public AnalysesController(AnalysisService analysisService) {
        this.analysisService = analysisService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_analyses:read')"))
    public ResponseEntity<Object> getAllAnalyses(@RequestParam(required = false) Integer page,
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
            var analyses = analysisService.getAllAnalyses(pageRequest, filterBy, search);
            return ResponseEntity.ok(analyses);
        }
        var analyses = analysisService.getAllAnalyses();
        return ResponseEntity.ok(analyses);
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:read')")
    public ResponseEntity<AnalysisDTO> getAnalysis(@PathVariable String id) {
        var analysisDTO = analysisService.getAnalysis(id);
        return Objects.nonNull(analysisDTO) ?ResponseEntity.ok(analysisDTO) : ResponseEntity.noContent().build();
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:save')")
    public ResponseEntity<Object> createAnalysis(@RequestBody AnalysisDTO analysisDTO) {
        return analysisService.createAnalysis(analysisDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:save')")
    public ResponseEntity<Object> updateAnalysis(@PathVariable Long id, @RequestBody AnalysisDTO analysisDTO) {
        return analysisService.updateAnalysis(id, analysisDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:save')")
    public ResponseEntity<Boolean> deleteAnalysis(@PathVariable Long id) {
        return analysisService.deleteAnalysis(id);
    }

}