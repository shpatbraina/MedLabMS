package com.medlabms.statsservice.services.clients;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(value = "identity-service")
public interface IdentityServiceClient {

    @GetMapping(value = "/stats", produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<Object> getStatistics();
}
