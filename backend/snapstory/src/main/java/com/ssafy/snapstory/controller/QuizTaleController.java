package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.service.QuizTaleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Api(value = "퀴즈 동화 API", tags = {"QuizTale"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tales")
@CrossOrigin("*")
public class QuizTaleController {
    private final QuizTaleService quizTaleService;

    @GetMapping("/incomplete")
    @ApiOperation(value = "미완성 퀴즈 동화 전체 조회", notes = "퀴즈 동화 전체 조회해서 미완성한 리스트 반환")
    public ResultResponse<List<QuizTale>> getQuizTalesIncomplete(Authentication authentication) {
        return ResultResponse.success(quizTaleService.getQuizTalesIncomplete(Integer.parseInt(authentication.getName())));
    }
    @GetMapping("/complete")
    @ApiOperation(value = "완성 퀴즈 동화 전체 조회", notes = "퀴즈 동화 전체 조회해서 완성 리스트 반환")
    public ResultResponse<List<QuizTale>> getQuizTalesComplete(Authentication authentication) {
        return ResultResponse.success(quizTaleService.getQuizTalesComplete(Integer.parseInt(authentication.getName())));
    }
}
