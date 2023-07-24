package com.medlabms;

import com.medlabms.models.entities.Audit;
import com.medlabms.services.AuditService;
import io.micronaut.configuration.kafka.annotation.KafkaListener;
import io.micronaut.configuration.kafka.annotation.Topic;

@KafkaListener
public class AuditConsumer {

    private final AuditService auditService;

    public AuditConsumer(AuditService auditService) {
        this.auditService = auditService;
    }

    @Topic("medlabms.audit")
    public void receive(Audit audit) {
        auditService.saveAudit(audit).map(audit1 -> {
            System.out.println(audit1);
            return audit1;
        }).subscribe();
    }
}
