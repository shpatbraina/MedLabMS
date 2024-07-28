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
import org.springframework.web.bind.annotation.*;

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
    public ResponseEntity<Object> getAllUsers(@RequestParam(required = false) Integer page,
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
            var list = userService.getAllUsers(pageRequest, filterBy, search);
            return ResponseEntity.ok(list);
        }
        var list = userService.getAllUsers();
        return ResponseEntity.ok(list);
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:read')")
    public ResponseEntity<UserDTO> getUser(@PathVariable String id) {

        var user = userService.getUser(id);
        return Objects.nonNull(user) ? ResponseEntity.ok(user) : ResponseEntity.noContent().build();
    }

    @PostMapping(value = "", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public ResponseEntity<Object> createUser(@RequestBody UserDTO userDTO) {
        return userService.createUser(userDTO);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public ResponseEntity<Object> updateUser(@PathVariable Long id, @RequestBody UserDTO userDTO) {
        return userService.updateUser(id, userDTO);
    }

    @DeleteMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public ResponseEntity<Object> deleteUser(@PathVariable Long id) {
        return userService.deleteUser(id);
    }

    @PutMapping(value = "/changePassword", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_self:save')")
    public ResponseEntity<Object> changePassword(Authentication authentication, @RequestBody ChangePasswordDTO changePasswordDTO) {
        return changePasswordDTO.getPassword() != null ?
                userService.changePassword(authentication, changePasswordDTO.getPassword()) :
                ResponseEntity.badRequest().body(ErrorDTO.builder()
                        .errorMessage("Password didn't met requirements!").build());
    }

    @PutMapping(value = "/resetPassword/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("hasAuthority('SCOPE_users:save')")
    public ResponseEntity<Object> resetPassword(@PathVariable Long id) {
        return userService.resetPassword(id);
    }

}
