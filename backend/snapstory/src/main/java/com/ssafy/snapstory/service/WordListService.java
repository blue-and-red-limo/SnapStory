package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.word.Word;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.domain.wordList.dto.AddWordReq;
import com.ssafy.snapstory.domain.wordList.dto.AddWordRes;
import com.ssafy.snapstory.domain.wordList.dto.DeleteWordRes;
import com.ssafy.snapstory.domain.wordList.dto.GetWordRes;
import com.ssafy.snapstory.exception.conflict.WordListDuplicateException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.exception.not_found.WordNotFoundException;
import com.ssafy.snapstory.exception.not_found.WordListNotFoundException;
import com.ssafy.snapstory.repository.WordListRepository;
import com.ssafy.snapstory.repository.WordRepository;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class WordListService {
    private final WordListRepository wordListRepository;
    private final UserRepository userRepository;
    private final WordRepository wordRepository;

    public List<GetWordRes> getWordLists(int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        // 유저의 단어장에 저장된 단어 리스트 조회
        List<WordList> wordLists = wordListRepository.findAllByUser_UserId(user.getUserId());
        List<GetWordRes> getWordResList = new ArrayList<>();
        System.out.println(wordLists.toString());
        for (WordList wordList:wordLists) {
            getWordResList.add(GetWordRes.builder()
                    .wordListId(wordList.getWordListId())
                    .wordExampleEng(wordList.getWordExampleEng())
                    .wordExampleKor(wordList.getWordExampleKor())
                    .word(wordList.getWord())
                    .build());
        }
        return getWordResList;
    }

    public GetWordRes getWordList(String word, int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        // 유저의 단어장에 해당 단어가 있는지 조회
        WordList wordList = wordListRepository.findByUser_UserIdAndWord_WordEng(user.getUserId(), word).orElseThrow(WordNotFoundException::new);
        GetWordRes getWordRes = GetWordRes.builder()
                .wordListId(wordList.getWordListId())
                .wordExampleEng(wordList.getWordExampleEng())
                .wordExampleKor(wordList.getWordExampleKor())
                .word(wordList.getWord())
                .build();
        return getWordRes;
    }

    public AddWordRes addWordList(AddWordReq addWordReq, int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        // 유저의 단어장에 해당 단어가 있는지 조회
        Optional<WordList> wordList = wordListRepository.findByUser_UserIdAndWord_WordEng(user.getUserId(), addWordReq.getWord());
        AddWordRes addWordRes;
        // 해당 단어가 저장되어있지 않은 경우 단어를 단어장에 추가(생성)
        if (wordList.isEmpty()) {
            Word word = wordRepository.findByWordEng(addWordReq.getWord()).orElseThrow(WordNotFoundException::new);
            WordList newWordList = WordList.builder()
                    .wordExampleEng(addWordReq.getWordExampleEng())
                    .wordExampleKor(addWordReq.getWordExampleKor())
                    .word(word)
                    .user(user)
                    .build();
            wordListRepository.save(newWordList);
            addWordRes = new AddWordRes(
                    newWordList.getWordListId(),
                    newWordList.getWordExampleEng(),
                    newWordList.getWordExampleKor(),
                    newWordList.getWord(),
                    newWordList.getUser()
            );
        } else {
            // 이미 해당 단어가 저장되어 있는 경우
            throw new WordListDuplicateException();
        }
        return addWordRes;
    }

    public DeleteWordRes deleteWordList(int wordListId, int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        WordList wordList = wordListRepository.findByUser_UserIdAndWordListId(user.getUserId(), wordListId).orElseThrow(WordNotFoundException::new);
        wordListRepository.deleteById(wordList.getWordListId());
        DeleteWordRes deleteWordRes = new DeleteWordRes(wordList.getWordListId());
        return deleteWordRes;
    }
}
