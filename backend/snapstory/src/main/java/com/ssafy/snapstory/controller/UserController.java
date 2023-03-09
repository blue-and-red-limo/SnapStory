package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.user.dto.CreateUserReq;
import com.ssafy.snapstory.domain.user.dto.CreateUserRes;
import com.ssafy.snapstory.domain.user.dto.DeleteUserRes;
import com.ssafy.snapstory.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "유저 API", tags = {"User"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/users")
@CrossOrigin("*")
public class UserController {
    private final UserService userService;
    @GetMapping("/{userId}")
    @ApiOperation(value = "유저 정보 조회", notes = "userId로 유저 정보 제공")
    public ResultResponse<CreateUserRes> getUser(@PathVariable int userId) {
        return ResultResponse.success(userService.getUser(userId));
    }

    @GetMapping("email/{email}")
    @ApiOperation(value = "이메일로 유저 정보 조회", notes = "이메일로 유저 정보 제공")
    public ResultResponse<CreateUserRes> getUserByEmail(@PathVariable String email) {
        return ResultResponse.success(userService.getUserByEmail(email));
    }

    @DeleteMapping
    @ApiOperation(value = "유저 삭제", notes = "유저 삭제")
    public ResultResponse<DeleteUserRes>deleteUser(Authentication authentication){
//        System.out.println(authentication.getName());
        return ResultResponse.success(userService.deleteUser(authentication.getName()));
    }

    @PostMapping
    @ApiOperation(value = "유저 회원가입", notes = "유저 회원가입")
    public ResultResponse<CreateUserRes>createUser(@RequestBody CreateUserReq createUserReq){
        return ResultResponse.success(userService.createUser(createUserReq));
    }
}
