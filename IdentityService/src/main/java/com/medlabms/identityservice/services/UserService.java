package com.medlabms.identityservice.services;

import com.medlabms.core.exceptions.ChildFoundException;
import com.medlabms.identityservice.models.dtos.ErrorDTO;
import com.medlabms.identityservice.models.dtos.UserDTO;
import com.medlabms.identityservice.models.entities.User;
import com.medlabms.identityservice.repositories.UserRepository;
import com.medlabms.identityservice.services.mapper.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.Collections;

import static javax.ws.rs.core.Response.Status.CREATED;
import static javax.ws.rs.core.Response.Status.OK;

@Slf4j
@Service
public class UserService {

    private UserRepository userRepository;
    private KeycloakUserService keycloakUserService;
    private GroupService groupService;
    private UserMapper userMapper;

    public UserService(UserRepository userRepository, KeycloakUserService keycloakUserService, GroupService groupService, UserMapper userMapper) {
        this.userRepository = userRepository;
        this.keycloakUserService = keycloakUserService;
        this.groupService = groupService;
        this.userMapper = userMapper;
    }

    public Mono<Page<UserDTO>> getAllUsers(PageRequest pageRequest) {

        return userRepository.findAllBy(pageRequest)
                .flatMap(user -> groupService.getGroup(user.getGroupId())
                        .flatMap(groupDTO -> {
                            var userDTO = userMapper.entityToDtoModel(user);
                            userDTO.setGroupName(groupDTO.getName());
                            return Mono.just(userDTO);
                        }))
                .collectList()
                .zipWith(userRepository.count())
                .flatMap(objects -> Mono.just(new PageImpl<>(objects.getT1(), pageRequest, objects.getT2())));
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
                        if (CREATED.getStatusCode() == response.getStatus()) {
                            return keycloakUserService.searchUser(userDTO.getUsername())
                                    .zipWhen(userRepresentation1 -> {
                                        User user = userMapper.kcEntityToEntity(userRepresentation1);
                                        user.setGroupId(userDTO.getGroupId());
                                        return userRepository
                                                .save(user)
                                                .doOnError(throwable -> log.error(throwable.getMessage()));
                                    })
                                    .flatMap(objects -> Mono.just(objects.getT2()))
                                    .map(user -> ResponseEntity.ok(userMapper.entityToDtoModel(user)));
                        } else {
                            return Mono.just(ResponseEntity.badRequest().body(response.readEntity(String.class)));
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
                                if (OK.getStatusCode() == response.getStatus()) {
                                    User user1 = userMapper.kcEntityToEntity(response.readEntity(UserRepresentation.class));
                                    user1.setId(user.getId());
                                    user1.setGroupId(userDTO.getGroupId());
                                    userMapper.updateUser(user1, user);
                                    return userRepository.save(user)
                                            .flatMap(user2 -> Mono.just(ResponseEntity.ok(userMapper.entityToDtoModel(user2))));
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
                                                return Mono.just(ResponseEntity.ok(aBoolean));
                                            } else {
                                                return Mono.just(ResponseEntity.badRequest().build());
                                            }
                                        }))));
    }
}