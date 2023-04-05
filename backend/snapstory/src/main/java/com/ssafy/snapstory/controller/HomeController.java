package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.aiTale.dto.*;
import com.ssafy.snapstory.service.AiTaleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RequiredArgsConstructor
@CrossOrigin("*")
public class HomeController {
    @GetMapping("/")
    @ApiOperation(value = "index 페이지", notes = "index 페이지")
    public String index(){
        return "index";
    }
}
