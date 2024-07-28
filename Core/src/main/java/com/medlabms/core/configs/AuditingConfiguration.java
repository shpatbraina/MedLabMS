package com.medlabms.core.configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.Optional;

@Configuration
@EnableJpaAuditing
public class AuditingConfiguration {
    @Bean
    AuditorAware<String> auditorAware() {
        return () -> Optional.of(((Jwt)SecurityContextHolder.getContext()
                .getAuthentication()
                .getPrincipal())
                .getClaim("preferred_username")
                .toString());
    }
}
