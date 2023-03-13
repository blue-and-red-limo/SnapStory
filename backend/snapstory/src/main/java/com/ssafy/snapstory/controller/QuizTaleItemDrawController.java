package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemReq;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemRes;
import com.ssafy.snapstory.service.QuizTaleItemDrawService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tale-items")
@CrossOrigin("*")
public class QuizTaleItemDrawController {
    private final QuizTaleItemDrawService quizTaleItemDrawService;

    @PostMapping
    public ResultResponse<DrawQuizTaleItemRes> drawQuizTaleItem(@RequestBody DrawQuizTaleItemReq drawQuizTaleItemReq, Authentication authentication) {
        return ResultResponse.success(quizTaleItemDrawService.drawQuizTaleItem(drawQuizTaleItemReq, authentication.getName()));
    }
}
