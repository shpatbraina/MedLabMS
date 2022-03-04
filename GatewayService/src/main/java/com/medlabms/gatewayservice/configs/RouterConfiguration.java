package com.medlabms.gatewayservice.configs;

import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

@Component
public class RouterConfiguration {

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                .route("identity-service", r -> r.path("/session/**").uri("lb://identity-service"))
                .route("identity-service", r -> r.path("/groups/**").uri("lb://identity-service"))
                .route("identity-service", r -> r.path("/users/**").uri("lb://identity-service"))
                .route("lab-service", r -> r.path("/patients/**").uri("lb://lab-service"))
                .build();
    }

    @Bean
    @LoadBalanced
    public WebClient.Builder loadBalancedWebClientBuilder() {
        return WebClient.builder();
    }
}