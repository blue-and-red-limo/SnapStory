package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemReq;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemRes;
import com.ssafy.snapstory.service.QuizTaleItemDrawService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@Api(value = "퀴즈 동화 API", tags = {"QuizTaleItemDraw"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tale-items")
@CrossOrigin("*")
public class QuizTaleItemDrawController {
    private final QuizTaleItemDrawService quizTaleItemDrawService;

    @PostMapping
    @ApiOperation(value = "퀴즈 동화 아이템 손그림 성공", notes = "손그림 퀴즈 성공한 동화 아이템을 저장")
    public ResultResponse<DrawQuizTaleItemRes> drawQuizTaleItem(@RequestBody DrawQuizTaleItemReq drawQuizTaleItemReq, Authentication authentication) {
        return ResultResponse.success(quizTaleItemDrawService.drawQuizTaleItem(drawQuizTaleItemReq, Integer.parseInt(authentication.getName())));
    }
}
