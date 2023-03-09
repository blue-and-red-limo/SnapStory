package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.service.QuizTaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tales")
@CrossOrigin("*")
public class QuizTaleController {
    private final QuizTaleService quizTaleService;

    @GetMapping("/incomplete")
    public ResultResponse<List<QuizTale>> getQuizTalesIncomplete(Authentication authentication) {
        return ResultResponse.success(quizTaleService.getQuizTalesIncomplete(authentication.getName()));
    }
    @GetMapping("/complete")
    public ResultResponse<List<QuizTale>> getQuizTalesComplete(Authentication authentication) {
        return ResultResponse.success(quizTaleService.getQuizTalesComplete(authentication.getName()));
    }
}
