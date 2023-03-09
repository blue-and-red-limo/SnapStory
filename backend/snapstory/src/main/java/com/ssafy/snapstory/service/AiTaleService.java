package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.aiTale.AiTale;
import com.ssafy.snapstory.domain.aiTale.dto.GetAiTaleRes;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.user.dto.CreateUserReq;
import com.ssafy.snapstory.domain.user.dto.CreateUserRes;
import com.ssafy.snapstory.domain.user.dto.DeleteUserRes;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.exception.conflict.EmailDuplicateException;
import com.ssafy.snapstory.exception.not_found.EmailNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.repository.AiTaleRepository;
import com.ssafy.snapstory.repository.UserRepository;
import com.ssafy.snapstory.repository.WordListRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AiTaleService {
    private final AiTaleRepository aiTaleRepository;
    private final WordListRepository wordListRepository;
    private final UserRepository userRepository;


//    public List<GetAiTaleRes> getAiTaleAll(int userId) {
//        List<GetAiTaleRes> getAiTaleResList = new ArrayList<>();
//        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
//        //1. 단어장에서 유저 아이디를 이용해서 검색을 한다.
//        Optional<List<WordList>> wordLists = wordListRepository.findAllByUser(user);
//        //단어가 있으면, 동화가 있는지를 체크해서 동화가 있으면 리스트에 담아준다.
//        if(wordLists.get().size()>0){
//            for (WordList wordList:wordLists.get()) {
//                AiTale aiTale = aiTaleRepository.findByWordList(wordList).orElseThrow();
//            }
//        }
//    }
}
