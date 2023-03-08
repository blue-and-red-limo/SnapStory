package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository  extends JpaRepository<User, Integer> {
}
