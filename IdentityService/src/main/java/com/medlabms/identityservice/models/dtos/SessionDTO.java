package com.medlabms.identityservice.models.dtos;

import lombok.Data;

import java.util.List;

@Data
public class SessionDTO {

	private String name;
	private boolean readGroups;
	private boolean addGroups;
	private boolean readUsers;
	private boolean addUsers;
	private boolean readPatients;
	private boolean addPatients;

	public SessionDTO(String name, List<String> permissions) {

		this.name = name;
		this.readGroups = permissions.contains("groups:read");
		this.addGroups = permissions.contains("groups:save");
		this.readUsers = permissions.contains("users:read");
		this.addUsers = permissions.contains("users:save");
		this.readPatients = permissions.contains("patients:read");
		this.addPatients = permissions.contains("patients:save");
	}

}
