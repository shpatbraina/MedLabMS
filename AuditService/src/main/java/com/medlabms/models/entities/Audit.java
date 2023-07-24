package com.medlabms.models.entities;


import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity(name = "audits")
public class Audit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column
    private String type;
    @Column
    private String action;
    @Column
    private String description;
    @Column
    private String resourceName;
    @Column
    private String modifiedBy;
    @Column
    private LocalDateTime date;

}
