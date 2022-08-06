package com.medlabms.identityservice.models.dtos;

import lombok.Data;

import java.util.List;

@Data
public class SessionDTO {

	private String name;
	private boolean addSelf;
	private boolean readGroups;
	private boolean addGroups;
	private boolean readUsers;
	private boolean addUsers;
	private boolean readPatients;
	private boolean addPatients;
	private boolean readAnalysesGroups;
	private boolean addAnalysesGroups;
	private boolean readAnalyses;
	private boolean addAnalyses;
	private boolean readVisits;
	private boolean addVisits;

	public SessionDTO(String name, List<String> permissions) {

		this.name = name;
		this.addSelf = permissions.contains("self:save");
		this.readGroups = permissions.contains("groups:read");
		this.addGroups = permissions.contains("groups:save");
		this.readUsers = permissions.contains("users:read");
		this.addUsers = permissions.contains("users:save");
		this.readPatients = permissions.contains("patients:read");
		this.addPatients = permissions.contains("patients:save");
		this.readAnalyses = permissions.contains("analyses:read");
		this.addAnalyses = permissions.contains("analyses:save");
		this.readAnalysesGroups = permissions.contains("analysesGroups:read");
		this.addAnalysesGroups = permissions.contains("analysesGroups:save");
		this.readVisits = permissions.contains("visits:read");
		this.addVisits = permissions.contains("visits:save");
	}

}
