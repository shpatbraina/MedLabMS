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

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

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

    public Page<UserDTO> getAllUsers(PageRequest pageRequest, String filterBy, String search) {

        var list = findBy(pageRequest, filterBy, search).stream()
                .map(user -> {
                    var groupDTO = groupService.getGroup(user.getGroupId());
                    var userDTO = userMapper.entityToDtoModel(user);
                    userDTO.setGroupName(groupDTO.getName());
                    return userDTO;
                })
                .collect(Collectors.toList());

        var count = countBy(filterBy, search);

        return new PageImpl<>(list, pageRequest, count);
    }

    private List<User> findBy(PageRequest pageRequest, String filterBy, String search) {
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

    private Long countBy(String filterBy, String search) {
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

    public List<User> getAllUsers() {
        return userRepository.findAllBy(PageRequest.ofSize(Integer.MAX_VALUE).withSort(Sort.Direction.ASC, "id"));
    }
    public UserDTO getUser(String id) {
        var user = keycloakUserService.getUser(id);
        return userMapper.kcEntityToDtoModel(user.orElseThrow());
    }

    public ResponseEntity<Object> createUser(UserDTO userDTO) {
        UserRepresentation userRepresentation = userMapper.dtoModelToKCEntity(userDTO);
        userRepresentation.setEnabled(true);
        var groupDTO = groupService.getGroup(userDTO.getGroupId());
        userRepresentation.setGroups(Collections.singletonList(groupDTO.getName()));
        var response = keycloakUserService.createUser(userRepresentation);
        if (HttpStatus.valueOf(response.orElseThrow().getStatus()).is2xxSuccessful()) {
            var userRepresentation1 = keycloakUserService.searchUser(userDTO.getUsername());
            User user = userMapper.kcEntityToEntity(userRepresentation1.orElseThrow());
            user.setGroupId(userDTO.getGroupId());
            try{
                userRepository.save(user);
            }catch (Exception e) {
                log.error(e.getMessage());
            }
           auditProducerService.audit(AuditMessageDTO.builder()
                           .resourceName(userDTO.getFirstName().concat(" ").concat(userDTO.getLastName()))
                           .action("Create").type("User").build());
           return ResponseEntity.ok(userMapper.entityToDtoModel(user));
        } else {
            return ResponseEntity.badRequest().body(ErrorDTO.builder().errorMessage(response.orElseThrow().readEntity(String.class)).build());
        }
    }

    public ResponseEntity<Object> updateUser(Long id, UserDTO userDTO) {
        UserRepresentation userRepresentation = userMapper.dtoModelToKCEntity(userDTO);
        var user = userRepository.findById(id);
        var groupDTO = groupService.getGroup(userDTO.getGroupId());
        userRepresentation.setGroups(Collections.singletonList(groupDTO.getName()));
        var response = keycloakUserService.updateUser(user.orElseThrow().getKcId(), userRepresentation);
        if (response.isPresent() && HttpStatus.valueOf(response.get().getStatus()).is2xxSuccessful()) {
            User user1 = userMapper.kcEntityToEntity((UserRepresentation) ((Optional) response.get().getEntity()).get());
            user1.setId(user.orElseThrow().getId());
            user1.setGroupId(userDTO.getGroupId());
            userMapper.updateUser(user1, user.orElseThrow());
            var userDTO1 = userRepository.save(user.orElseThrow());
            auditProducerService.audit(AuditMessageDTO.builder()
                    .resourceName(userDTO.getFirstName().concat(" ").concat(userDTO.getLastName()))
                    .action("Update").type("User").build());
            return ResponseEntity.ok(userMapper.entityToDtoModel(userDTO1));
        } else {
            return ResponseEntity.badRequest().body(ErrorDTO.builder()
                    .errorMessage(response.orElseThrow().getEntity().toString()).build());
        }
    }

    public ResponseEntity<Object> deleteUser(Long id) {
        var user = userRepository.findById(id);
        try{
         userRepository.delete(user.orElseThrow());
        }catch (Exception e) {
            throw new ChildFoundException();
        }
        var deleted = keycloakUserService.deleteUser(user.orElseThrow().getKcId());
        if (deleted) {
            auditProducerService.audit(AuditMessageDTO.builder().resourceName(user.orElseThrow().getFirstName()
                            .concat(" ").concat(user.orElseThrow().getLastName()))
                            .action("Delete").type("User").build());
            return ResponseEntity.ok(deleted);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    public ResponseEntity<Object> changePassword(Authentication authentication, String newPassword) {
        String kcId = ((JwtAuthenticationToken) authentication).getTokenAttributes().get("sub").toString();
        var changePassword = keycloakUserService.changePassword(kcId, newPassword);
        if (changePassword) {
            return ResponseEntity.ok(changePassword);
        }
        return  ResponseEntity.badRequest().body(changePassword);
    }

    public ResponseEntity<Object> resetPassword(Long id) {
        var user = userRepository.findById(id)
                .map(User::getKcId);
        var result = keycloakUserService.resetPassword(user.orElseThrow());
        if (result) {
            return ResponseEntity.ok(result);
        }
        return ResponseEntity.badRequest().body(ErrorDTO.builder()
                .errorMessage("Failed to reset password for user with id ".concat(Long.toString(id))).build());
    }
}