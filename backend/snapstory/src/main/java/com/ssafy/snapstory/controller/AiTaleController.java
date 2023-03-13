package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.aiTale.dto.CreateAiTaleReq;
import com.ssafy.snapstory.domain.aiTale.dto.CreateAiTaleRes;
import com.ssafy.snapstory.domain.aiTale.dto.DeleteAiTaleRes;
import com.ssafy.snapstory.domain.aiTale.dto.GetAiTaleRes;
import com.ssafy.snapstory.service.AiTaleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Api(value = "AI동화 API", tags = {"AiTale"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/ai-tales")
@CrossOrigin("*")
public class AiTaleController {
    private final AiTaleService aiTaleService;

    @GetMapping
    @ApiOperation(value = "AI 동화 전체 조회", notes = "AI 동화 전체 조회해서 리스트로 반환")
    public ResultResponse<List<GetAiTaleRes>> getAiTaleAll(Authentication authentication) {
        return ResultResponse.success(aiTaleService.getAiTaleAll(Integer.parseInt(authentication.getName())));
    }

    @GetMapping("/{aiTaleId}")
    @ApiOperation(value = "AI 동화 조회", notes = "AI 동화 조회")
    public ResultResponse<GetAiTaleRes> getAiTale(@PathVariable int aiTaleId, Authentication authentication) {
        return ResultResponse.success(aiTaleService.getAiTale(aiTaleId, Integer.parseInt(authentication.getName())));
    }

    @PostMapping
    @ApiOperation(value = "AI 동화 생성", notes = "AI 동화 생성")
    public ResultResponse<CreateAiTaleRes> createAiTale(@RequestBody CreateAiTaleReq createAiTaleReq, Authentication authentication) {
        return ResultResponse.success(aiTaleService.createAiTale(createAiTaleReq, Integer.parseInt(authentication.getName())));
    }

//    @PutMapping("/{aiTaleId}")
//    @ApiOperation(value = "AI 동화 수정", notes = "AI 동화 수정")
//    public ResultResponse<CreateAiTaleRes> createAiTale(@RequestBody CreateAiTaleReq createAiTaleReq, Authentication authentication) {
//        return ResultResponse.success(aiTaleService.createAiTale(createAiTaleReq, Integer.parseInt(authentication.getName())));
//    }

    @DeleteMapping("/{aiTaleId}")
    @ApiOperation(value = "AI 동화 삭제", notes = "AI 동화 삭제")
    public ResultResponse<DeleteAiTaleRes> deleteAiTale(@PathVariable int aiTaleId, Authentication authentication) {
        return ResultResponse.success(aiTaleService.deleteAiTale(aiTaleId, authentication.getName()));
    }
}
