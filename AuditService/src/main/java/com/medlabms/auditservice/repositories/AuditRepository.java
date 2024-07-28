package com.medlabms.auditservice.repositories;

import com.medlabms.auditservice.models.entities.Audit;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuditRepository extends JpaRepository<Audit, Long> {

    List<Audit> findAllBy(Pageable pageable);
    List<Audit> findByActionContainsIgnoreCase(String action, Pageable pageable);
    List<Audit> findByTypeContainsIgnoreCase(String type, Pageable pageable);
    List<Audit> findByModifiedByContainsIgnoreCase(String modifiedBy, Pageable pageable);

    Long countByActionContainsIgnoreCase(String action);
    Long countByTypeContainsIgnoreCase(String type);
    Long countByModifiedByContainsIgnoreCase(String modifiedBy);
}
