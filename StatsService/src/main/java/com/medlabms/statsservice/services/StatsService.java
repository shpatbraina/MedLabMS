package com.medlabms.statsservice.services;

import com.medlabms.statsservice.services.clients.IdentityServiceClient;
import com.medlabms.statsservice.services.clients.LabServiceClient;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class StatsService {

    private final LabServiceClient labServiceClient;
    private final IdentityServiceClient identityServiceClient;

    public StatsService(LabServiceClient labServiceClient, IdentityServiceClient identityServiceClient) {
        this.labServiceClient = labServiceClient;
        this.identityServiceClient = identityServiceClient;
    }

    public Map<String, Number> getStatistics() {
        var labServiceBody = (Map<String, Number>)labServiceClient.getStatistics().getBody();
        var identityServiceBody = (Map<String, Number>)identityServiceClient.getStatistics().getBody();
        identityServiceBody.putAll(labServiceBody);
        return identityServiceBody;
    }
}
