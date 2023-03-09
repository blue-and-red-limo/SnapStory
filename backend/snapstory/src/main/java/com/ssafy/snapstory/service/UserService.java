package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.user.dto.CreateUserReq;
import com.ssafy.snapstory.domain.user.dto.CreateUserRes;
import com.ssafy.snapstory.domain.user.dto.DeleteUserRes;
import com.ssafy.snapstory.exception.conflict.EmailDuplicateException;
import com.ssafy.snapstory.exception.not_found.EmailNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public CreateUserRes getUser(int userId) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        return CreateUserRes.builder().userId(user.getUserId()).email(user.getEmail()).name(user.getName()).uid(user.getUid()).build();
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(EmailNotFoundException::new);
    }

    public CreateUserRes createUser(CreateUserReq createUserReq) {
        Optional<User> user = userRepository.findByEmail(createUserReq.getEmail());
        CreateUserRes createUserRes;
        if (!user.isPresent()) {
            User newUser = User.builder().email(createUserReq.getEmail()).name(createUserReq.getName()).uid(createUserReq.getUid()).build();
            userRepository.save(newUser);
            createUserRes = new CreateUserRes(newUser.getUserId(), newUser.getEmail(), newUser.getName(), newUser.getUid());

        } else {
            throw new EmailDuplicateException();
        }

        return createUserRes;
    }

    public DeleteUserRes deleteUser(String userId) {
        User user = userRepository.findById(Integer.valueOf(userId)).orElseThrow(UserNotFoundException::new);
        userRepository.deleteById(user.getUserId());
        DeleteUserRes deleteUserRes = new DeleteUserRes(user.getUserId(),user.getEmail(),user.getName(),user.getUid());
        return deleteUserRes;
    }
}
