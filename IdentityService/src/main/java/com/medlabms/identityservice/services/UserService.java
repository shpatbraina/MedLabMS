package com.medlabms.identityservice.services;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.core.models.dtos.AuditMessageDTO;
import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.identityservice.models.dtos.UserDTO;
import com.medlabms.identityservice.models.entities.User;
import com.medlabms.identityservice.repositories.UserRepository;
import com.medlabms.identityservice.services.mappers.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
public class UserService {

    private UserRepository userRepository;
    private KeycloakUserService keycloakUserService;
    private GroupService groupService;
    private AuditProducerService auditProducerService;
    private UserMapper userMapper;

    public UserService(UserRepository userRepository, KeycloakUserService keycloakUserService, GroupService groupService, AuditProducerService auditProducerService, UserMapper userMapper) {
        this.userRepository = userRepository;
        this.keycloakUserService = keycloakUserService;
        this.groupService = groupService;
        this.auditProducerService = auditProducerService;
        this.userMapper = userMapper;
    }

    public Mono<Page<UserDTO>> getAllUsers(PageRequest pageRequest, String filterBy, String search) {

        return findBy(pageRequest, filterBy, search)
                .flatMap(user -> groupService.getGroup(user.getGroupId())
                        .flatMap(groupDTO -> {
                            var userDTO = userMapper.entityToDtoModel(user);
                            userDTO.setGroupName(groupDTO.getName());
                            return Mono.just(userDTO);
                        }))
                .collectList()
                .zipWith(countBy(filterBy, search))
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
    }

    private Flux<User> findBy(PageRequest pageRequest, String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "firstName" -> userRepository.findByFirstNameContainingIgnoreCase(search, pageRequest);
                case "lastName" -> userRepository.findByLastNameContainingIgnoreCase(search, pageRequest);
                case "email" -> userRepository.findByEmailContainingIgnoreCase(search, pageRequest);
                case "username" -> userRepository.findByUsernameContainingIgnoreCase(search, pageRequest);
                case "groupId" -> userRepository.findByGroupId(Long.parseLong(search), pageRequest);
                default -> userRepository.findAllBy(pageRequest);
            };
        }
        return userRepository.findAllBy(pageRequest);
    }

    private Mono<Long> countBy(String filterBy, String search) {
        if (Objects.nonNull(search) && !search.isBlank()) {
            return switch (filterBy) {
                case "firstName" -> userRepository.countByFirstNameContainingIgnoreCase(search);
                case "lastName" -> userRepository.countByLastNameContainingIgnoreCase(search);
                case "email" -> userRepository.countByEmailContainingIgnoreCase(search);
                case "username" -> userRepository.countByUsernameContainingIgnoreCase(search);
                case "groupId" -> userRepository.countByGroupId(Long.parseLong(search));
                default -> userRepository.count();
            };
        }
        return userRepository.count();
    }

    public Mono<List<User>> getAllUsers() {
        return userRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE).withSort(Sort.Direction.ASC, "id")).collectList();
    }
    public Mono<UserDTO> getUser(String id) {
        return keycloakUserService.getUser(id)
                .flatMap(userRepresentation -> Mono.just(userMapper.kcEntityToDtoModel(userRepresentation)));
    }

    public Mono<ResponseEntity<Object>> createUser(UserDTO userDTO) {
        UserRepresentation userRepresentation = userMapper.dtoModelToKCEntity(userDTO);
        userRepresentation.setEnabled(true);
        return groupService.getGroup(userDTO.getGroupId()).flatMap(groupDTO -> {
            userRepresentation.setGroups(Collections.singletonList(groupDTO.getName()));
            return keycloakUserService.createUser(userRepresentation)
                    .flatMap(response -> {
                        if (HttpStatus.valueOf(response.getStatus()).is2xxSuccessful()) {
                            return keycloakUserService.searchUser(userDTO.getUsername())
                                    .zipWhen(userRepresentation1 -> {
                                        User user = userMapper.kcEntityToEntity(userRepresentation1);
                                        user.setGroupId(userDTO.getGroupId());
                                        return userRepository
                                                .save(user)
                                                .doOnError(throwable -> log.error(throwable.getMessage()));
                                    })
                                    .flatMap(objects -> Mono.just(objects.getT2()))
                                    .flatMap(user -> auditProducerService.audit(AuditMessageDTO.builder().resourceName(userDTO.getFirstName().concat(" ").concat(userDTO.getLastName())).action("Create").type("User").build())
                                            .then(Mono.just(ResponseEntity.ok(userMapper.entityToDtoModel(user)))));
                        } else {
                            return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(response.readEntity(String.class)).build()));
                        }
                    });
        });
    }

    public Mono<ResponseEntity<Object>> updateUser(Long id, UserDTO userDTO) {
        UserRepresentation userRepresentation = userMapper.dtoModelToKCEntity(userDTO);
        return userRepository.findById(id)
                .flatMap(user -> groupService.getGroup(userDTO.getGroupId()).flatMap(groupDTO -> {
                    userRepresentation.setGroups(Collections.singletonList(groupDTO.getName()));
                    return keycloakUserService.updateUser(user.getKcId(), userRepresentation)
                            .flatMap(response -> {
                                if (HttpStatus.valueOf(response.getStatus()).is2xxSuccessful()) {
                                    User user1 = userMapper.kcEntityToEntity(response.readEntity(UserRepresentation.class));
                                    user1.setId(user.getId());
                                    user1.setGroupId(userDTO.getGroupId());
                                    userMapper.updateUser(user1, user);
                                    return userRepository.save(user)
                                            .flatMap(user2 -> auditProducerService.audit(AuditMessageDTO.builder().resourceName(userDTO.getFirstName().concat(" ").concat(userDTO.getLastName())).action("Update").type("User").build())
                                                    .then(Mono.just(ResponseEntity.ok(userMapper.entityToDtoModel(user2)))));
                                } else {
                                    return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                                            .errorMessage(response.getEntity().toString()).build()));
                                }
                            });
                }));
    }

    public Mono<ResponseEntity<Object>> deleteUser(Long id) {
        return userRepository.findById(id).flatMap(user ->
                Mono.defer(() -> userRepository.delete(user))
                        .onErrorResume(throwable -> {
                            throw new ChildFoundException();
                        })
                        .then(Mono.defer(() ->
                                keycloakUserService.deleteUser(user.getKcId())
                                        .flatMap(aBoolean -> {
                                            if (aBoolean) {
                                                return auditProducerService.audit(AuditMessageDTO.builder().resourceName(user.getFirstName().concat(" ").concat(user.getLastName())).action("Delete").type("User").build())
                                                        .then(Mono.just(ResponseEntity.ok(aBoolean)));
                                            } else {
                                                return Mono.just(ResponseEntity.badRequest().build());
                                            }
                                        }))));
    }

    public Mono<ResponseEntity<Object>> changePassword(Authentication authentication, String newPassword) {
        String kcId = ((JwtAuthenticationToken) authentication).getTokenAttributes().get("sub").toString();
        return keycloakUserService.changePassword(kcId, newPassword)
                .flatMap(aBoolean -> {
                    if (aBoolean)
                        return Mono.just(ResponseEntity.ok(aBoolean));
                    return Mono.just(ResponseEntity.badRequest().body(aBoolean));
                });
    }

    public Mono<ResponseEntity<Object>> resetPassword(Long id) {
        return userRepository.findById(id)
                .map(User::getKcId)
                .flatMap(keycloakId -> keycloakUserService.resetPassword(keycloakId))
                .flatMap(aBoolean -> {
                    if (aBoolean)
                        return Mono.just(ResponseEntity.ok(aBoolean));
                    return Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                            .errorMessage("Failed to reset password for user with id ".concat(Long.toString(id))).build()));
                });
    }
}