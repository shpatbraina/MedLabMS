package com.medlabms.auditservice;

import com.medlabms.auditservice.services.AuditService;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.r2dbc.repository.config.EnableR2dbcRepositories;
import org.springframework.web.reactive.config.EnableWebFlux;

@SpringBootApplication
@EnableR2dbcRepositories
@EnableWebFlux
public class AuditServiceApplication {

	public static void main(String[] args) {
		var configurableApplicationContext = SpringApplication.run(AuditServiceApplication.class, args);

		configurableApplicationContext.getBean(AuditService.class).consumeAuditConsumerDTO().subscribe();
	}

}
