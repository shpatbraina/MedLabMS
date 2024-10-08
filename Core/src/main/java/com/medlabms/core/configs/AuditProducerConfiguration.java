package com.medlabms.core.configs;

import com.medlabms.core.models.dtos.AuditMessageDTO;
import org.springframework.boot.autoconfigure.kafka.KafkaProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;

import java.util.Map;

@Configuration
public class AuditProducerConfiguration {

    @Bean
    public KafkaTemplate<String, AuditMessageDTO> auditProducerTemplate(
            KafkaProperties properties) {
        Map<String, Object> props = properties.buildProducerProperties(null);
        return new KafkaTemplate<>(new DefaultKafkaProducerFactory<>(props));
    }
}
