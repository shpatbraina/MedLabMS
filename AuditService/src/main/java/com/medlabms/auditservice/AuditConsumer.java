package com.medlabms.auditservice;

import com.medlabms.auditservice.services.AuditService;
import com.medlabms.auditservice.services.mappers.AuditMapper;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class AuditConsumer {

    private final AuditService auditService;
    private final AuditMapper auditMapper;

    public AuditConsumer(AuditService auditService, AuditMapper auditMapper)
    {
        this.auditService = auditService;
        this.auditMapper = auditMapper;
    }

    @KafkaListener(topics = {"${AUDIT_PRODUCER_DTO_TOPIC}"})
    public void receive(AuditMessageDTO auditMessageDTO) {
        auditService.saveAudit(auditMapper.dtoModelToEntity(auditMessageDTO));
    }
}
