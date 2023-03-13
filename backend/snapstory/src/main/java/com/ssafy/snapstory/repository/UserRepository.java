package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository  extends JpaRepository<User, Integer> {
    Optional<User> findByEmail(String email);
    Optional<User> findByUid(String uid);
}
