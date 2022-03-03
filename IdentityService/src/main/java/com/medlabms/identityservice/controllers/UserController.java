package com.medlabms.identityservice.controllers;

import com.medlabms.identityservice.models.dtos.UserDTO;
import com.medlabms.identityservice.models.entities.User;
import com.medlabms.identityservice.services.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.Objects;

@RestController
@RequestMapping("/users")
public class UserController {

    private UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('SCOPE_users:read')")
    public Mono<ResponseEntity<Page<User>>> getAllUsers(@RequestParam Integer page, @RequestParam Integer size) {
        return userService.getAllUsers(PageRequest.of(page,size).withSort(Sort.Direction.ASC, "id")).flatMap(users -> Mono.just(ResponseEntity.ok(users)));
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:read')")
    public Mono<ResponseEntity<UserDTO>> getUser(@PathVariable String id) {
        return userService.getUser(id)
                .flatMap(userDTO -> Objects.nonNull(userDTO) ?
                        Mono.just(ResponseEntity.ok(userDTO)) : Mono.just(ResponseEntity.noContent().build()));
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public Mono<ResponseEntity<Object>> createUser(@RequestBody UserDTO userDTO) {
        return userService.createUser(userDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public Mono<ResponseEntity<Object>> updateUser(@PathVariable Long id, @RequestBody UserDTO userDTO) {
        return userService.updateUser(id, userDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public Mono<ResponseEntity<Object>> deleteUser(@PathVariable Long id) {
        return userService.deleteUser(id);
    }

}
