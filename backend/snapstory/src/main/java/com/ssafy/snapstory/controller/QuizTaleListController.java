package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTaleList.dto.AddQuizTaleListReq;
import com.ssafy.snapstory.domain.quizTaleList.dto.AddQuizTaleListRes;
import com.ssafy.snapstory.service.QuizTaleListService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tale-list")
@CrossOrigin("*")
public class QuizTaleListController {
    private final QuizTaleListService quizTaleListService;

    @PostMapping
    public ResultResponse<AddQuizTaleListRes> addQuizTaleList(@RequestBody AddQuizTaleListReq addQuizTaleListReq, Authentication authentication) {
        return ResultResponse.success(quizTaleListService.addQuizTaleList(addQuizTaleListReq, Integer.parseInt(authentication.getName())));
    }
}
