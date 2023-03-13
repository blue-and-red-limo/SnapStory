package com.ssafy.snapstory.controller;

import com.ssafy.snapstory.domain.ResultResponse;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.domain.wordList.dto.AddWordReq;
import com.ssafy.snapstory.domain.wordList.dto.AddWordRes;
import com.ssafy.snapstory.domain.wordList.dto.DeleteWordRes;
import com.ssafy.snapstory.service.WordListService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("${API}/word-list")
@CrossOrigin("*")
public class WordListController {
    private final WordListService wordListService;
    @GetMapping
    public ResultResponse<List<WordList>> getWordLists(Authentication authentication) {
        return ResultResponse.success(wordListService.getWordLists(authentication.getName()));
    }

    @GetMapping("/{wordListId}")
    public ResultResponse<WordList> getWordList(@PathVariable int wordListId, Authentication authentication) {
        return ResultResponse.success(wordListService.getWordList(wordListId, authentication.getName()));
    }

    @PostMapping
    public ResultResponse<AddWordRes> addWordList(@RequestBody AddWordReq addWordReq, Authentication authentication) {
        return ResultResponse.success(wordListService.addWordList(addWordReq, authentication.getName()));
    }

    @DeleteMapping("/{wordListId}")
    public ResultResponse<DeleteWordRes> deleteWordList(@PathVariable int wordListId, Authentication authentication) {
        return ResultResponse.success(wordListService.deleteWordList(wordListId, authentication.getName()));
    }
}
