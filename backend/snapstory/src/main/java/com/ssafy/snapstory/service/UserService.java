package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    public User getUser(int userId) {
        return userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
    }


}
