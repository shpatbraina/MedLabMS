package com.medlabms.gatewayservice.configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.function.RouterFunction;
import org.springframework.web.servlet.function.ServerResponse;

import static org.springframework.cloud.gateway.server.mvc.filter.LoadBalancerFilterFunctions.lb;
import static org.springframework.cloud.gateway.server.mvc.handler.GatewayRouterFunctions.route;
import static org.springframework.cloud.gateway.server.mvc.handler.HandlerFunctions.http;
import static org.springframework.cloud.gateway.server.mvc.predicate.GatewayRequestPredicates.path;

@Configuration
public class RouterConfiguration {

    @Bean
    public RouterFunction<ServerResponse> gatewayRouterFunctionsPath() {
        return route().route(path("/session/**", "/groups/**", "/users/**"), http())
                .filter(lb("identity-service")).build()
                .andRoute(path("/patients/**", "/analysesGroups/**", "/analyses/**", "/visits/**"), http())
                .filter(lb("lab-service"))
                .andRoute(path("/audits/**"), http())
                .filter(lb("audit-service"))
                .andRoute(path("/stats/**", "/reports/**"), http())
                .filter(lb("stats-service"));
    }
}