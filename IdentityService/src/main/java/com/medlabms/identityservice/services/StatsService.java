package com.medlabms.identityservice.services;

import com.medlabms.identityservice.repositories.GroupRepository;
import com.medlabms.identityservice.repositories.UserRepository;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class StatsService {

    private final GroupRepository groupRepository;
    private final UserRepository userRepository;

    public StatsService(GroupRepository groupRepository, UserRepository userRepository) {
        this.groupRepository = groupRepository;
        this.userRepository = userRepository;
    }

    public Map<String, Number> getStatistics() {
        Map<String, Number> map = new HashMap<>();

        map.put("groupsCount", groupRepository.count());
        map.put("usersCount", userRepository.count());
        return map;
    }
}
