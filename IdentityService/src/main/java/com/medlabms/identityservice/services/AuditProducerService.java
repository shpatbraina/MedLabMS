package com.medlabms.identityservice.services;

import com.medlabms.core.models.dtos.AuditMessageDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.reactive.ReactiveKafkaProducerTemplate;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
@Slf4j
public class AuditProducerService {

    @Value("${AUDIT_PRODUCER_DTO_TOPIC}")
    private String topic;

    private final ReactiveKafkaProducerTemplate<String, AuditMessageDTO> auditProducerTemplate;

    public AuditProducerService(ReactiveKafkaProducerTemplate<String, AuditMessageDTO> auditProducerTemplate) {
        this.auditProducerTemplate = auditProducerTemplate;
    }

    public Mono<Void> audit(AuditMessageDTO auditMessageDTO) {
        log.info("send to topic={}, {}={},", topic, AuditMessageDTO.class.getSimpleName(), auditMessageDTO);
        auditMessageDTO.setDate(LocalDateTime.now());
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        ((JwtAuthenticationToken) securityContext.getAuthentication())
                                .getTokenAttributes().get("preferred_username").toString())
                .map(s -> {
                    auditMessageDTO.setModifiedBy(s);
                    return auditMessageDTO;
                })
                .flatMap(auditMessageDTO1 -> auditProducerTemplate.send(topic, auditMessageDTO1)
                        .doOnSuccess(senderResult -> log.info("sent {} offset : {}", auditMessageDTO1, senderResult.recordMetadata().offset()))
                        .then());
    }
}
