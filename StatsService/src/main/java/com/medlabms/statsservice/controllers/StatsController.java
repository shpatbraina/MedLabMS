package com.medlabms.statsservice.controllers;

import com.medlabms.statsservice.services.StatsService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/stats")
public class StatsController {

    private final StatsService statsService;

    public StatsController(StatsService statsService) {
        this.statsService = statsService;
    }

    @GetMapping
    @PreAuthorize(("hasAuthority('SCOPE_dashboard:read')"))
    public ResponseEntity<Object> retrieveStats() {
        return ResponseEntity.ok(statsService.getStatistics());
    }
}
