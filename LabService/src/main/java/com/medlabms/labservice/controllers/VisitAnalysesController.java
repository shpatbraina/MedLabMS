package com.medlabms.labservice.controllers;

import com.medlabms.labservice.models.dtos.VisitAnalysisDTO;
import com.medlabms.labservice.services.VisitAnalysesService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("visits/analyses")
public class VisitAnalysesController
{

    private VisitAnalysesService visitAnalysesService;

    public VisitAnalysesController(VisitAnalysesService visitAnalysesService) {
        this.visitAnalysesService = visitAnalysesService;
    }

    @GetMapping("{visitId}")
    @PreAuthorize(("hasAuthority('SCOPE_visits:read')"))
    public Mono<ResponseEntity<Object>> getAllVisitAnalyses(@PathVariable Long visitId) {
        var visitAnalysisDTOS = visitAnalysesService.getAllVisitAnalyses(visitId);
        return Mono.just(ResponseEntity.ok(visitAnalysisDTOS));
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public ResponseEntity<Object> createVisitAnalyses(@RequestBody List<VisitAnalysisDTO> visitAnalysisDTOs) {
        return visitAnalysesService.createVisitAnalyses(visitAnalysisDTOs);
    }

    @PutMapping(value = "/{visitId}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_visits:save')")
    public ResponseEntity<Object> updateVisitAnalyses(@PathVariable Long visitId, @RequestBody List<VisitAnalysisDTO> visitAnalysisDTOs) {
        return visitAnalysesService.updateVisitAnalysis(visitId, visitAnalysisDTOs);
    }

}