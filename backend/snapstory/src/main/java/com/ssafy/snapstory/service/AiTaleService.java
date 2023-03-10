package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.aiTale.AiTale;
import com.ssafy.snapstory.domain.aiTale.dto.CreateAiTaleReq;
import com.ssafy.snapstory.domain.aiTale.dto.CreateAiTaleRes;
import com.ssafy.snapstory.domain.aiTale.dto.GetAiTaleRes;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.user.dto.CreateUserReq;
import com.ssafy.snapstory.domain.user.dto.CreateUserRes;
import com.ssafy.snapstory.domain.user.dto.DeleteUserRes;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.exception.bad_request.BadAccessException;
import com.ssafy.snapstory.exception.conflict.AiTaleDuplicateException;
import com.ssafy.snapstory.exception.conflict.EmailDuplicateException;
import com.ssafy.snapstory.exception.not_found.AiTaleNotFoundException;
import com.ssafy.snapstory.exception.not_found.EmailNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.exception.not_found.WordListNotFoundException;
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


    public List<GetAiTaleRes> getAiTaleAll(int userId) {
        List<GetAiTaleRes> getAiTaleResList = new ArrayList<>();
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //1. 단어장에서 유저 아이디를 이용해서 검색을 한다.
        List<WordList> wordLists = wordListRepository.findAllByUser(user);
        //단어가 있으면, 동화가 있는지를 체크해서 동화가 있으면 리스트에 담아준다.
        if(!wordLists.isEmpty()){
            for (WordList wordList : wordLists) {
                Optional<AiTale> aiTale = aiTaleRepository.findByWordList(wordList);
                if(aiTale.isPresent()){
                    getAiTaleResList.add(GetAiTaleRes.builder().aiTaleId(aiTale.get().getAiTaleId())
                                    .wordEng(wordList.getWord().getWordEng())
                                    .wordKor(wordList.getWord().getWordKor())
                            .contentEng(aiTale.get().getContentEng()).contentKor(aiTale.get().getContentKor())
                            .image(aiTale.get().getImage()).sound(aiTale.get().getSound()).build());
                }
            }
        }
        return getAiTaleResList;
    }

    public CreateAiTaleRes createAiTale(CreateAiTaleReq createAiTaleReq, int userId) {
        //유저 있는지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //이미 단어장으로 생성된 동화가 있는지 체크
        Optional<AiTale> temp = aiTaleRepository.findByWordList(wordListRepository.findById(createAiTaleReq.getWordListId()).orElseThrow(WordListNotFoundException::new));
        if(temp.isPresent())
            throw new AiTaleDuplicateException();

        AiTale aiTale = AiTale.builder()
                .contentEng(createAiTaleReq.getContentEng())
                .contentKor(createAiTaleReq.getContentKor())
                .image(createAiTaleReq.getImage())
                .sound(createAiTaleReq.getSound())
                .wordList(wordListRepository.findById(createAiTaleReq.getWordListId()).orElseThrow(WordListNotFoundException::new))
                .build();
        aiTaleRepository.save(aiTale);
        CreateAiTaleRes createAiTaleRes = new CreateAiTaleRes(aiTale.getAiTaleId(), aiTale.getWordList().getWordListId(), aiTale.getContentEng(), aiTale.getContentKor(), aiTale.getImage(), aiTale.getSound());
        return createAiTaleRes;
    }

    public GetAiTaleRes getAiTale(int aiTaleId, int userId) {
        //유저 있는지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //그 동화가 유저가 쓴게 맞는지 확인 -> 동화 조회해서 단어장 인덱스의 유저가 나인지 확인
        AiTale aiTale = aiTaleRepository.findById(aiTaleId).orElseThrow(AiTaleNotFoundException::new);
        if(aiTale.getWordList().getUser().getUserId() != userId)
            throw new BadAccessException();
        GetAiTaleRes getAiTaleRes = GetAiTaleRes.builder()
                .aiTaleId(aiTale.getAiTaleId())
                .wordEng(aiTale.getWordList().getWord().getWordEng())
                .wordKor(aiTale.getWordList().getWord().getWordKor())
                .contentEng(aiTale.getContentEng())
                .contentKor(aiTale.getContentKor())
                .image(aiTale.getImage())
                .sound(aiTale.getSound())
                .build();
        return getAiTaleRes;


    }
}
