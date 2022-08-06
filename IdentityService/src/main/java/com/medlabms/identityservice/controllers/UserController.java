package com.medlabms.identityservice.controllers;

import com.medlabms.core.models.dtos.ErrorDTO;
import com.medlabms.identityservice.models.dtos.ChangePasswordDTO;
import com.medlabms.identityservice.models.dtos.UserDTO;
import com.medlabms.identityservice.services.UserService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
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
    public Mono<ResponseEntity<Object>> getAllUsers(@RequestParam(required = false) Integer page,
                                                           @RequestParam(required = false) Integer size,
                                                           @RequestParam(required = false) String sortBy,
                                                           @RequestParam(required = false) Boolean sortDesc,
                                                           @RequestParam(required = false) String filterBy,
                                                           @RequestParam(required = false) String search) {
        if(page != null && size != null) {
            var pageRequest = PageRequest.of(page, size);
            if (Objects.nonNull(sortBy) && !sortBy.isBlank() && Objects.nonNull(sortDesc)) {
                Sort.Direction sortDirection = sortDesc ? Sort.Direction.DESC : Sort.Direction.ASC;
                pageRequest = pageRequest.withSort(sortDirection, sortBy);
            }
            return userService.getAllUsers(pageRequest, filterBy, search).flatMap(users -> Mono.just(ResponseEntity.ok(users)));
        }
        return userService.getAllUsers().flatMap(users -> Mono.just(ResponseEntity.ok(users)));
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

    @PutMapping(value = "/changePassword", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_self:save')")
    public Mono<ResponseEntity<Object>> changePassword(Authentication authentication, @RequestBody ChangePasswordDTO changePasswordDTO) {
        return changePasswordDTO.getPassword() != null ?
                userService.changePassword(authentication, changePasswordDTO.getPassword()) :
                Mono.just(ResponseEntity.badRequest().body(ErrorDTO.builder()
                        .errorMessage("Password didn't met requirements!").build()));
    }

    @PutMapping(value = "/resetPassword/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public Mono<ResponseEntity<Object>> resetPassword(@PathVariable Long id) {
        return userService.resetPassword(id);
    }

}
