package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.quizTaleList.dto.AddQuizTaleListReq;
import com.ssafy.snapstory.domain.quizTaleList.dto.AddQuizTaleListRes;
import com.ssafy.snapstory.service.QuizTaleListService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@Api(value = "완성된 퀴즈 동화 저장 API", tags = {"QuizTaleList"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/quiz-tale-list")
@CrossOrigin("*")
public class QuizTaleListController {
    private final QuizTaleListService quizTaleListService;

    @PostMapping
    @ApiOperation(value = "퀴즈 동화 완성", notes = "성공한 퀴즈 동화를 저장")
    public ResultResponse<AddQuizTaleListRes> addQuizTaleList(@RequestBody AddQuizTaleListReq addQuizTaleListReq, Authentication authentication) {
        return ResultResponse.success(quizTaleListService.addQuizTaleList(addQuizTaleListReq, Integer.parseInt(authentication.getName())));
    }
}
