package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.service.AiTaleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Api(value = "AI동화 API", tags = {"AiTale"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/ai-tales")
@CrossOrigin("*")
public class AiTaleController {
    private final AiTaleService aiTaleService;
//    @GetMapping
//    @ApiOperation(value = "AI 동화 전체 조회", notes = "AI 동화 전체 조회해서 리스트로 반환")
//    public ResultResponse<> getAiTaleAll() {
//        return ResultResponse.success(aiTaleService);
//    }

}
