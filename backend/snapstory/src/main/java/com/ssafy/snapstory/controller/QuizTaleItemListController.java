package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTaleItemList.dto.DrawQuizTaleItemList;
import com.ssafy.snapstory.service.QuizTaleItemListService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@Api(value = "퀴즈 동화 API", tags = {"QuizTaleItemList"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tale-items")
@CrossOrigin("*")
public class QuizTaleItemListController {
    private final QuizTaleItemListService quizTaleItemListService;

    @GetMapping("/{quizTaleId}")
    @ApiOperation(value = "퀴즈 동화 개별 조회", notes = "퀴즈 동화 개별 조회")
    public ResultResponse<DrawQuizTaleItemList> getDrawQuizTaleItemList(@PathVariable int quizTaleId, Authentication authentication) {
        return ResultResponse.success(quizTaleItemListService.getDrawQuizTaleItemList(quizTaleId, Integer.parseInt(authentication.getName())));
    }
}
