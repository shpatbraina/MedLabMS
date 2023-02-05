package com.medlabms.labservice.services;

import com.medlabms.core.models.dtos.AuditMessageDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.reactive.ReactiveKafkaProducerTemplate;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

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
        return auditProducerTemplate.send(topic, auditMessageDTO)
                .doOnSuccess(senderResult -> log.info("sent {} offset : {}", auditMessageDTO, senderResult.recordMetadata().offset()))
                .then();
    }
}
