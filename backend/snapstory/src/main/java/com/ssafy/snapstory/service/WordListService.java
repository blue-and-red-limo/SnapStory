package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.word.Word;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.domain.wordList.dto.AddWordReq;
import com.ssafy.snapstory.domain.wordList.dto.AddWordRes;
import com.ssafy.snapstory.domain.wordList.dto.DeleteWordRes;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.exception.not_found.WordNotFoundException;
import com.ssafy.snapstory.exception.not_found.WordListNotFoundException;
import com.ssafy.snapstory.repository.WordListRepository;
import com.ssafy.snapstory.repository.WordRepository;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class WordListService {
    private final WordListRepository wordListRepository;
    private final UserRepository userRepository;
    private final WordRepository wordRepository;

    public List<WordList> getWordLists() {
        return wordListRepository.findAll();
    }

    public WordList getWordList(int wordListId) {
        return wordListRepository.findById(wordListId).orElseThrow(WordListNotFoundException::new);
    }

    public AddWordRes addWordList(AddWordReq addWordReq) {
        Word word = wordRepository.findById(addWordReq.getWordId()).orElseThrow(WordNotFoundException::new);
        User user = userRepository.findById(addWordReq.getUserId()).orElseThrow(UserNotFoundException::new);
        AddWordRes addWordRes;
        WordList newWordList = WordList.builder()
                .wordExampleEng(addWordReq.getWordExampleEng())
                .wordExampleKor(addWordReq.getWordExampleKor())
                .wordExampleSound(addWordReq.getWordExampleSound())
                .word(word)
                .user(user)
                .build();
        wordListRepository.save(newWordList);
        addWordRes = new AddWordRes(
                newWordList.getWordListId(),
                newWordList.getWordExampleEng(),
                newWordList.getWordExampleKor(),
                newWordList.getWordExampleSound(),
                newWordList.getWord(),
                newWordList.getUser()
        );
        return addWordRes;
    }

    public DeleteWordRes deleteWordList(int wordListId) {
        WordList wordList = wordListRepository.findById(wordListId).orElseThrow(WordListNotFoundException::new);
        wordListRepository.deleteById(wordListId);
        DeleteWordRes deleteWordRes = new DeleteWordRes(wordList.getWordListId());
        return deleteWordRes;
    }
}
