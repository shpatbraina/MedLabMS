package com.medlabms.auditservice.configs;

import com.medlabms.core.models.dtos.AuditMessageDTO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.kafka.KafkaProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.reactive.ReactiveKafkaConsumerTemplate;
import reactor.kafka.receiver.ReceiverOptions;

import java.util.Collections;

@Configuration
public class AuditConsumerConfiguration {

    @Bean
    public ReceiverOptions<String, AuditMessageDTO> kafkaReceiverOptions(@Value(value = "${" +
            "AUDIT_CONSUMER_DTO_TOPIC}") String topic, KafkaProperties kafkaProperties) {
        ReceiverOptions<String, AuditMessageDTO> basicReceiverOptions = ReceiverOptions.create(kafkaProperties.buildConsumerProperties());
        return basicReceiverOptions.subscription(Collections.singletonList(topic));
    }

    @Bean
    public ReactiveKafkaConsumerTemplate<String, AuditMessageDTO> auditConsumerTemplate(ReceiverOptions<String, AuditMessageDTO> kafkaReceiverOptions) {
        return new ReactiveKafkaConsumerTemplate<>(kafkaReceiverOptions);
    }
}
