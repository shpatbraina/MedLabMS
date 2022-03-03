package com.medlabms.identityservice.services;

import lombok.extern.slf4j.Slf4j;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.GroupResource;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.RoleScopeResource;
import org.keycloak.representations.idm.GroupRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Slf4j
@Service
public class KeycloakGroupService {

    private RealmResource realmResource;

    public KeycloakGroupService(Keycloak keycloak) {
        this.realmResource = keycloak.realm(keycloak.realms().findAll().get(0).getRealm());
    }

    public Mono<GroupRepresentation> getGroup(String id) {
        try {
            GroupResource groupResource = realmResource.groups().group(id);
            GroupRepresentation groupRepresentation = groupResource.toRepresentation();
            return Mono.just(groupRepresentation);
        } catch (Exception e) {
            log.error("Failed to get group from keycloak with exception!", e);
            return Mono.empty();
        }
    }


    public Mono<GroupRepresentation> searchGroup(String name) {
        try {
            return Mono.just(realmResource.groups().groups(name, 0, 1).get(0));
        } catch (Exception e) {
            log.error("Failed to search group on keycloak with exception!", e);
            return Mono.empty();
        }
    }

    public Mono<Response> createGroup(GroupRepresentation groupRepresentation) {
        try {
            return Mono.just(realmResource.groups().add(groupRepresentation));
        } catch (Exception e) {
            log.error("Failed to create group in keycloak with exception!", e);
            return Mono.just(Response.status(Response.Status.BAD_REQUEST).build());
        }
    }

    public Mono<Response> updateGroup(String id, GroupRepresentation groupRepresentation) {
        try {
            GroupResource groupResource = realmResource.groups().group(id);
            groupResource.update(groupRepresentation);
            return getGroup(id).flatMap(groupRepresentation1 -> Mono.just(Response.ok(groupRepresentation1).build()));
        } catch (Exception e) {
            log.error("Failed to update group in keycloak with exception!");
            return Mono.just(Response.status(Response.Status.BAD_REQUEST).entity("Group with this name already exists!").build());
        }
    }

    public Mono<Boolean> deleteGroup(String id) {
        try {
            GroupResource groupResource = realmResource.groups().group(id);
            groupResource.remove();
            return Mono.just(true);
        } catch (Exception e) {
            log.error("Failed to delete group from keycloak with exception!", e);
            return Mono.just(false);
        }
    }

    public Flux<RoleRepresentation> getAllAvailableRoles(String id) {

        try {
            return Flux.fromIterable(realmResource.groups().group(id).roles().realmLevel().listAvailable().stream()
                    .filter(filterOutDefaultRoles()).collect(Collectors.toList()));
        } catch (Exception e) {
            log.error("Error while trying to get roles: {0} " + e.getMessage());
            return Flux.empty();
        }
    }

    public Flux<RoleRepresentation> getAllEffectiveRoles(String id) {

        try {
            return Flux.fromIterable(realmResource.groups().group(id).roles().realmLevel().listEffective());
        } catch (Exception e) {
            log.error("Error while trying to get roles: {0} " + e.getMessage());
            return Flux.empty();
        }
    }

    public Flux<RoleRepresentation> updateEffectiveRoles(String id, List<String> roles) {

        try {
            RoleScopeResource roleScopeResource = realmResource.groups().group(id).roles().realmLevel();
            roleScopeResource.remove(roleScopeResource.listEffective());
            roleScopeResource.add(roleScopeResource.listAvailable().stream()
                    .filter(roleRepresentation -> roles.contains(roleRepresentation.getName()))
                    .toList());
            return Flux.fromIterable(roleScopeResource.listEffective());
        } catch (Exception e) {
            log.error("Error while trying to update roles: {0} " + e.getMessage());
            throw e;
        }
    }

    private Predicate<RoleRepresentation> filterOutDefaultRoles() {
        List<String> defaultRoleNames = new ArrayList<>();
        defaultRoleNames.add("offline_access");
        defaultRoleNames.add("uma_authorization");
        defaultRoleNames.add("default-roles-medlabms");
        return o -> !defaultRoleNames.contains(o.getName());
    }
}
