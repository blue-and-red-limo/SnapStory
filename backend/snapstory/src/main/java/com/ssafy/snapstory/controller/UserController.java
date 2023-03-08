package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/users")
@CrossOrigin("*")
public class UserController {
    private final UserService userService;
    @GetMapping("/{userId}")
    public ResultResponse<User> getUser(@PathVariable int userId) {
        return ResultResponse.success(userService.getUser(userId));
    }
}
