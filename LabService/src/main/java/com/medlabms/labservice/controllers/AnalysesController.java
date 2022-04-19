package com.medlabms.labservice.controllers;

import java.util.Objects;

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

import com.medlabms.labservice.models.dtos.AnalysisDTO;
import com.medlabms.labservice.services.AnalysisService;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("analyses")
public class AnalysesController {

    private AnalysisService analysisService;

    public AnalysesController(AnalysisService analysisService) {
        this.analysisService = analysisService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_analyses:read')"))
    public Mono<ResponseEntity<Object>> getAllAnalyses(@RequestParam(required = false) Integer page, @RequestParam(required = false) Integer size) {
        if(page != null && size != null)
            return analysisService.getAllAnalyses(PageRequest.of(page,size).withSort(Sort.Direction.ASC, "id")).flatMap(analyses -> Mono.just(ResponseEntity.ok(analyses)));
        return analysisService.getAllAnalyses().flatMap(analysisDTOS -> Mono.just(ResponseEntity.ok(analysisDTOS)));
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:read')")
    public Mono<ResponseEntity<AnalysisDTO>> getAnalysis(@PathVariable String id) {
        return analysisService.getAnalysis(id)
                .flatMap(analysisDTO -> Objects.nonNull(analysisDTO) ?
                        Mono.just(ResponseEntity.ok(analysisDTO)) : Mono.just(ResponseEntity.noContent().build()));
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:save')")
    public Mono<ResponseEntity<Object>> createAnalysis(@RequestBody AnalysisDTO analysisDTO) {
        return analysisService.createAnalysis(analysisDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:save')")
    public Mono<ResponseEntity<Object>> updateAnalysis(@PathVariable Long id, @RequestBody AnalysisDTO analysisDTO) {
        return analysisService.updateAnalysis(id, analysisDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_analyses:save')")
    public Mono<ResponseEntity<Boolean>> deleteAnalysis(@PathVariable Long id) {
        return analysisService.deleteAnalysis(id);
    }

}