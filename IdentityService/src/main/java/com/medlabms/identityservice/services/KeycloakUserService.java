package com.medlabms.identityservice.services;

import lombok.extern.slf4j.Slf4j;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.GroupRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
public class KeycloakUserService {

    private RealmResource realmResource;

    public KeycloakUserService(Keycloak keycloak) {
        this.realmResource = keycloak.realm(keycloak.realms().findAll().get(0).getRealm());
    }

    public Optional<UserRepresentation> getUser(String id) {
        try {
            UserResource userResource = realmResource.users().get(id);
            UserRepresentation userRepresentation = userResource.toRepresentation();
            userRepresentation.setGroups(userResource.groups().stream().map(GroupRepresentation::getName).collect(Collectors.toList()));
            return Optional.of(userRepresentation);
        } catch (Exception e) {
            log.error("Failed to get user from keycloak with exception!", e);
            return Optional.empty();
        }
    }

    public Optional<UserRepresentation> searchUser(String username) {
        try {
            UserRepresentation userRepresentation = realmResource.users().search(username).get(0);
            UserResource userResource = realmResource.users().get(userRepresentation.getId());
            userRepresentation.setGroups(userResource.groups().stream().map(GroupRepresentation::getName).collect(Collectors.toList()));
            return Optional.of(userRepresentation);
        } catch (Exception e) {
            log.error("Failed to search user from keycloak with exception!", e);
            return Optional.empty();
        }
    }

    public Optional<Response> createUser(UserRepresentation userRepresentation) {
        try {
            Response response = realmResource.users().create(userRepresentation);
            if (HttpStatus.valueOf(response.getStatus()).is2xxSuccessful()) {
                var userRepresentation1 = searchUser(userRepresentation.getUsername());
                resetPassword(userRepresentation1.orElseThrow().getId());
                return Optional.of(response);
            }
            return Optional.empty();
        } catch (Exception e) {
            log.error("Failed to create user in keycloak with exception!", e);
            return Optional.of(Response.status(Response.Status.BAD_REQUEST).entity(e.getMessage()).build());
        }
    }

    public Optional<Response> updateUser(String id, UserRepresentation userRepresentation) {
        try {
            UserResource userResource = realmResource.users().get(id);
            userResource.update(userRepresentation);
            userResource.groups().forEach(groupRepresentation -> userResource.leaveGroup(groupRepresentation.getId()));
            userRepresentation.getGroups().stream()
                    .map(group -> realmResource.groups().groups(group, 0, 1).getFirst().getId())
                    .forEach(userResource::joinGroup);
            var user = getUser(id);
            return Optional.of(Response.ok(user).build());
        } catch (Exception e) {
            log.error("Failed to update user in keycloak with exception!");
            return Optional.of(Response.status(Response.Status.BAD_REQUEST).entity("User with these data already exists!").build());
        }
    }

    public Boolean resetPassword(String id) {
        try {
            UserResource userResource = realmResource.users().get(id);
            userResource.executeActionsEmail("ui-client", "http://localhost:8080/", List.of("UPDATE_PASSWORD"));
            return true;
        } catch (Exception e) {
            log.error("Failed to reset password for user in keycloak with exception!", e);
            return false;
        }
    }

    public Boolean changePassword(String id, String newPassword) {
        try {
            UserResource userResource = realmResource.users().get(id);
            CredentialRepresentation credentialRepresentation = new CredentialRepresentation();
            credentialRepresentation.setType(CredentialRepresentation.PASSWORD);
            credentialRepresentation.setTemporary(false);
            credentialRepresentation.setValue(newPassword);
            userResource.resetPassword(credentialRepresentation);
            return true;
        } catch (Exception e) {
            log.error("Failed to reset password for user in keycloak with exception!", e);
            return false;
        }
    }

    public Boolean deleteUser(String id) {
        try {
            UserResource userResource = realmResource.users().get(id);
            userResource.remove();
            return true;
        } catch (Exception e) {
            log.error("Failed to delete user in keycloak with exception!", e);
            return false;
        }
    }

}
