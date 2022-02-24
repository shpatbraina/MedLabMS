package com.medlabms.identityservice.services;

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

import static javax.ws.rs.core.Response.Status.CREATED;

@Slf4j
@Service
public class UserService {

    private UserRepository userRepository;
    private KeycloakUserService keycloakUserService;
    private UserMapper userMapper;

    public UserService(UserRepository userRepository, KeycloakUserService keycloakUserService, UserMapper userMapper) {
        this.userRepository = userRepository;
        this.keycloakUserService = keycloakUserService;
        this.userMapper = userMapper;
    }

    public Mono<Page<User>> getAllUsers(PageRequest pageRequest) {

        return userRepository.findAllBy(pageRequest)
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
        return keycloakUserService.createUser(userRepresentation)
                .flatMap(response -> {
                    if (CREATED.getStatusCode() == response.getStatus()) {
                        return keycloakUserService.searchUser(userDTO.getUsername())
                                .doOnSuccess(userRepresentation1 ->
                                        userRepository
                                                .save(userMapper.kcEntityToEntity(userRepresentation1))
                                                .subscribe()
                                )
                                .map(userRepresentation1 -> ResponseEntity.ok(userMapper.kcEntityToDtoModel(userRepresentation1)));
                    } else {
                        return Mono.just(ResponseEntity.badRequest().body(response.readEntity(String.class)));
                    }
                });
    }

    public Mono<ResponseEntity<Object>> updateUser(Long id, UserDTO userDTO) {
        UserRepresentation userRepresentation = userMapper.dtoModelToKCEntity(userDTO);
        return userRepository.findById(id)
                .flatMap(user -> keycloakUserService.updateUser(user.getKcId(), userRepresentation)
                       .doOnError(error -> ResponseEntity.badRequest().body(error))
                        .flatMap(userRepresentation1 -> {
                            User user1 = userMapper.kcEntityToEntity(userRepresentation1);
                            user1.setId(user.getId());
                            return userRepository.save(user1)
                                .flatMap(user2 -> Mono.just(ResponseEntity.ok(userMapper.entityToDtoModel(user2))));
                        }));
    }

    public Mono<ResponseEntity<Object>> deleteUser(Long id) {
        return userRepository.findById(id).flatMap(user -> keycloakUserService.deleteUser(user.getKcId())
                .flatMap(aBoolean -> {
                    if (aBoolean) {
                        return userRepository.delete(user).flatMap(unused -> Mono.just(ResponseEntity.ok(aBoolean)));
                    } else {
                        return Mono.just(ResponseEntity.badRequest().build());
                    }
                }));
    }

}
