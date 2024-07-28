package com.medlabms.identityservice.controllers;

import com.medlabms.identityservice.models.dtos.SessionDTO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class SessionController {

	@GetMapping("/session")
	@PreAuthorize("hasAuthority('SCOPE_default-roles-medlabms')")
	public SessionDTO session(Authentication authentication) {

		String username = ((JwtAuthenticationToken) authentication).getTokenAttributes().get("preferred_username").toString();
		List<?> permissions = (List<?>) ((Jwt)authentication.getPrincipal()).getClaims().get("roles");

		return new SessionDTO(username, permissions);
	}
}