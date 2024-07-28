package com.medlabms.identityservice.repositories;

import com.medlabms.identityservice.models.entities.Group;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {

    List<Group> findAllBy(Pageable pageable);
    List<Group> findByNameContainingIgnoreCase(String name, Pageable pageable);
    Group findByKcId(String keycloakId);
    Long countByNameContainingIgnoreCase(String name);
}
