package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.service.QuizTaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tales")
@CrossOrigin("*")
public class QuizTaleController {
    private final QuizTaleService quizTaleService;

    @GetMapping("/incomplete/{userId}")
    public ResultResponse<List<QuizTale>> getQuizTalesIncomplete(@PathVariable int userId) {
        return ResultResponse.success(quizTaleService.getQuizTalesIncomplete(userId));
    }
    @GetMapping("/complete/{userId}")
    public ResultResponse<List<QuizTale>> getQuizTalesComplete(@PathVariable int userId) {
        return ResultResponse.success(quizTaleService.getQuizTalesComplete(userId));
    }
}
