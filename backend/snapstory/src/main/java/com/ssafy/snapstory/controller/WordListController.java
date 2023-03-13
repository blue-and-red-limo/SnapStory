package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.domain.wordList.dto.AddWordReq;
import com.ssafy.snapstory.domain.wordList.dto.AddWordRes;
import com.ssafy.snapstory.domain.wordList.dto.DeleteWordRes;
import com.ssafy.snapstory.service.WordListService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Api(value = "단어장 API", tags = {"WordList"})
@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/word-list")
@CrossOrigin("*")
public class WordListController {
    private final WordListService wordListService;
    @GetMapping
    @ApiOperation(value = "단어장 전체 조회", notes = "단어장 전체 조회해서 리스트로 반환")
    public ResultResponse<List<WordList>> getWordLists(Authentication authentication) {
        return ResultResponse.success(wordListService.getWordLists(Integer.parseInt(authentication.getName())));
    }

    @GetMapping("/{wordListId}")
    @ApiOperation(value = "단어장 개별 단어 조회", notes = "단어장 개별 단어 조회")
    public ResultResponse<WordList> getWordList(@PathVariable int wordListId, Authentication authentication) {
        return ResultResponse.success(wordListService.getWordList(wordListId, Integer.parseInt(authentication.getName())));
    }

    @PostMapping
    @ApiOperation(value = "단어장에 단어 추가", notes = "단어장에 단어 추가")
    public ResultResponse<AddWordRes> addWordList(@RequestBody AddWordReq addWordReq, Authentication authentication) {
        return ResultResponse.success(wordListService.addWordList(addWordReq, Integer.parseInt(authentication.getName())));
    }

    @DeleteMapping("/{wordListId}")
    @ApiOperation(value = "단어 삭제", notes = "단어장에서 해당 단어 삭제")
    public ResultResponse<DeleteWordRes> deleteWordList(@PathVariable int wordListId, Authentication authentication) {
        return ResultResponse.success(wordListService.deleteWordList(wordListId, Integer.parseInt(authentication.getName())));
    }
}
