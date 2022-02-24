package com.medlabms.identityservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.data.r2dbc.repository.config.EnableR2dbcRepositories;
import org.springframework.web.reactive.config.EnableWebFlux;

@EnableEurekaClient
@SpringBootApplication
@EnableR2dbcRepositories
@EnableWebFlux
public class IdentityServiceApplication
{

	public static void main(String[] args)
	{
		SpringApplication.run(IdentityServiceApplication.class, args);
	}

}
