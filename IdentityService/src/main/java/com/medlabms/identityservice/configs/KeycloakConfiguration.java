package com.medlabms.identityservice.configs;

import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource(value = "classpath:keycloak.yml", factory = YamlPropertySourceFactory.class)
public class KeycloakConfiguration {

        @Value("${keycloak.credentials.secret}")
        private String secretKey;
        @Value("${keycloak.resource}")
        private String clientId;
        @Value("${keycloak.auth-server-url}")
        private String authUrl;
        @Value("${keycloak.realm}")
        private String realm;

    @Bean
    public Keycloak keycloak() {
        return KeycloakBuilder.builder()
                .grantType(OAuth2Constants.CLIENT_CREDENTIALS)
                .serverUrl(authUrl)
                .realm(realm)
                .clientId(clientId)
                .clientSecret(secretKey)
                .build();
    }
}