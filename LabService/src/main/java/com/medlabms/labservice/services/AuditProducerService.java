package com.medlabms.labservice.services;

import com.medlabms.core.models.dtos.AuditMessageDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@Slf4j
public class AuditProducerService {

    @Value("${AUDIT_PRODUCER_DTO_TOPIC}")
    private String topic;

    private final KafkaTemplate<String, AuditMessageDTO> auditProducerTemplate;

    public AuditProducerService(KafkaTemplate<String, AuditMessageDTO> auditProducerTemplate) {
        this.auditProducerTemplate = auditProducerTemplate;
    }

    public void audit(AuditMessageDTO auditMessageDTO) {
        log.info("send to topic={}, {}={},", topic, AuditMessageDTO.class.getSimpleName(), auditMessageDTO);
        auditMessageDTO.setDate(LocalDateTime.now());
        var username = ((JwtAuthenticationToken) SecurityContextHolder.getContext().getAuthentication())
                .getTokenAttributes().get("preferred_username").toString();
        auditMessageDTO.setModifiedBy(username);
        var senderResult = auditProducerTemplate.send(topic, auditMessageDTO);
        senderResult.whenComplete((stringAuditMessageDTOSendResult, throwable) ->
                log.info("sent {} offset : {}", auditMessageDTO, stringAuditMessageDTOSendResult.getRecordMetadata().offset()));
    }
}
