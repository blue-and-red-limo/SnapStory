package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTaleItemList.dto.DrawQuizTaleItemList;
import com.ssafy.snapstory.service.QuizTaleItemListService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tale-items")
@CrossOrigin("*")
public class QuizTaleItemListController {
    private final QuizTaleItemListService quizTaleItemListService;

    @GetMapping("/{quizTaleId}")
    public ResultResponse<DrawQuizTaleItemList> getDrawQuizTaleItemList(@PathVariable int quizTaleId, Authentication authentication) {
        return ResultResponse.success(quizTaleItemListService.getDrawQuizTaleItemList(quizTaleId, Integer.parseInt(authentication.getName())));
    }
}
