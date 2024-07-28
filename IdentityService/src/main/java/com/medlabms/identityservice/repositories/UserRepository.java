package com.medlabms.identityservice.repositories;

import com.medlabms.identityservice.models.entities.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    List<User> findAllBy(Pageable pageable);
    List<User> findByFirstNameContainingIgnoreCase(String firstName, Pageable pageable);
    List<User> findByLastNameContainingIgnoreCase(String lastName, Pageable pageable);
    List<User> findByEmailContainingIgnoreCase(String email, Pageable pageable);
    List<User> findByUsernameContainingIgnoreCase(String username, Pageable pageable);
    List<User> findByGroupId(Long groupId, Pageable pageable);
    User findByKcId(String keycloakId);


    Long countByFirstNameContainingIgnoreCase(String firstName);
    Long countByLastNameContainingIgnoreCase(String lastName);
    Long countByEmailContainingIgnoreCase(String email);
    Long countByUsernameContainingIgnoreCase(String username);
    Long countByGroupId(Long groupId);
}
