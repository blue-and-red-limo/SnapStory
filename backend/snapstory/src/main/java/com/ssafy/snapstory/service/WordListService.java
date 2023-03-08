package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.word.Word;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.domain.wordList.dto.AddWordReq;
import com.ssafy.snapstory.domain.wordList.dto.AddWordRes;
import com.ssafy.snapstory.exception.not_found.WordListNotFoundException;
import com.ssafy.snapstory.repository.WordListRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class WordListService {
    private final WordListRepository wordListRepository;
    public List<WordList> getWordLists() {
        return wordListRepository.findAll();
    }

    public WordList getWordList(int wordListId) {
        return wordListRepository.findById(wordListId).orElseThrow(WordListNotFoundException::new);
    }

    public AddWordRes addWordList(AddWordReq addWordReq){
        AddWordRes addWordRes;
        WordList newWordList = WordList.builder()
                .wordExampleEng(addWordReq.getWordExampleEng())
                .wordExampleKor(addWordReq.getWordExampleKor())
                .wordExampleSound(addWordReq.getWordExampleSound())
//                .word(word)
//                .user(user)
                .build();
        wordListRepository.save(newWordList);
        addWordRes = new AddWordRes(
                newWordList.getWordExampleEng(),
                newWordList.getWordExampleEng(),
                newWordList.getWordExampleSound(),
                newWordList.getWord(),
                newWordList.getUser()
        );
        return addWordRes;
    }
}
