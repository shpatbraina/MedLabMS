package com.medlabms.identityservice.services;

import lombok.extern.slf4j.Slf4j;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.representations.idm.GroupRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import javax.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
public class KeycloakUserService {

    private RealmResource realmResource;

    public KeycloakUserService(Keycloak keycloak) {
        this.realmResource = keycloak.realm(keycloak.realms().findAll().get(0).getRealm());
    }

    public Mono<UserRepresentation> getUser(String id) {
        try {
            UserResource userResource = realmResource.users().get(id);
            UserRepresentation userRepresentation = userResource.toRepresentation();
            userRepresentation.setGroups(userResource.groups().stream().map(GroupRepresentation::getName).collect(Collectors.toList()));
            return Mono.just(userRepresentation);
        } catch (Exception e) {
            log.error("Failed to get user from keycloak with exception!", e);
            return Mono.empty();
        }
    }

    public Mono<UserRepresentation> searchUser(String username) {
        try {
            UserRepresentation userRepresentation = realmResource.users().search(username).get(0);
            UserResource userResource = realmResource.users().get(userRepresentation.getId());
            userRepresentation.setGroups(userResource.groups().stream().map(GroupRepresentation::getName).collect(Collectors.toList()));
            return Mono.just(userRepresentation);
        } catch (Exception e) {
            log.error("Failed to search user from keycloak with exception!", e);
            return Mono.empty();
        }
    }

    public Mono<Response> createUser(UserRepresentation userRepresentation) {
        try {
            Response response = realmResource.users().create(userRepresentation);
            return searchUser(userRepresentation.getUsername()).flatMap(userRepresentation1 ->
                resetPassword(userRepresentation1.getId()).flatMap(aBoolean -> Mono.just(response)));
        } catch (Exception e) {
            log.error("Failed to create user in keycloak with exception!", e);
            return Mono.just(Response.status(Response.Status.BAD_REQUEST).build());
        }
    }

    public Mono<UserRepresentation> updateUser(String id, UserRepresentation userRepresentation) {
        try {
            UserResource userResource = realmResource.users().get(id);
            userResource.update(userRepresentation);
            userResource.groups().forEach(groupRepresentation -> userResource.leaveGroup(groupRepresentation.getId()));
            userRepresentation.getGroups().stream()
                    .map(group -> realmResource.groups().groups(group, 0, 1).get(0).getId())
                    .forEach(userResource::joinGroup);
            return getUser(id);
        } catch (Exception e) {
            log.error("Failed to update user in keycloak with exception!", e);
            return Mono.empty();
        }
    }

    public Mono<Boolean> resetPassword(String id) {
        try {
            UserResource userResource = realmResource.users().get(id);
            userResource.executeActionsEmail("ui-client", "http://localhost:8080/", List.of("UPDATE_PASSWORD"));
            return Mono.just(true);
        } catch (Exception e) {
            log.error("Failed to reset password for user in keycloak with exception!", e);
            return Mono.just(false);
        }
    }

    public Mono<Boolean> deleteUser(String id) {
        try {
            UserResource userResource = realmResource.users().get(id);
            userResource.remove();
            return Mono.just(true);
        } catch (Exception e) {
            log.error("Failed to delete user in keycloak with exception!", e);
            return Mono.just(false);
        }
    }

}
