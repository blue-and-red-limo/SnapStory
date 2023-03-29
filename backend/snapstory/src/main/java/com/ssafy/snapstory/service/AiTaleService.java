package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.aiTale.AiTale;
import com.ssafy.snapstory.domain.aiTale.dto.*;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.wordList.WordList;
import com.ssafy.snapstory.exception.bad_request.BadAccessException;
import com.ssafy.snapstory.exception.conflict.AiTaleDuplicateException;
import com.ssafy.snapstory.exception.not_found.AiTaleNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.exception.not_found.WordListNotFoundException;
import com.ssafy.snapstory.repository.AiTaleRepository;
import com.ssafy.snapstory.repository.UserRepository;
import com.ssafy.snapstory.repository.WordListRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AiTaleService {
    private final AiTaleRepository aiTaleRepository;
    private final WordListRepository wordListRepository;
    private final UserRepository userRepository;
    private final AwsS3Service awsS3Service;
    @Value("${aws-cloud.aws.s3.bucket.url}")
    private String bucketUrl;

    public List<GetAiTaleRes> getAiTaleAll(int userId) {
        List<GetAiTaleRes> getAiTaleResList = new ArrayList<>();
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //1. 단어장에서 유저 아이디를 이용해서 검색을 한다.
        List<WordList> wordLists = wordListRepository.findAllByUser(user);
        //단어가 있으면, 동화가 있는지를 체크해서 동화가 있으면 리스트에 담아준다.
        if (!wordLists.isEmpty()){
            for (WordList wordList : wordLists) {
                Optional<AiTale> aiTale = aiTaleRepository.findByWordList(wordList);
                if(aiTale.isPresent()){
                    getAiTaleResList.add(GetAiTaleRes.builder().aiTaleId(aiTale.get().getAiTaleId())
                                    .wordEng(wordList.getWord().getWordEng())
                                    .wordKor(wordList.getWord().getWordKor())
                            .contentEng(aiTale.get().getContentEng()).contentKor(aiTale.get().getContentKor())
                            .image(aiTale.get().getImage()).build());
                }
            }
        }
        return getAiTaleResList;
    }

    public CreateAiTaleRes createAiTale(CreateAiTaleReq createAiTaleReq, int userId) {
        //유저 있는지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //해당 단어가 유저의 단어장에 있는지 체크
        WordList wordList = wordListRepository.findByUser_UserIdAndWord_WordEng(userId, createAiTaleReq.getWord()).orElseThrow(WordListNotFoundException::new);
        //이미 단어장으로 생성된 동화가 있는지 체크
        Optional<AiTale> temp = aiTaleRepository.findByWordList(wordList);
        if (temp.isPresent())
            throw new AiTaleDuplicateException();

        AiTale aiTale = AiTale.builder()
                .contentEng(createAiTaleReq.getContentEng())
                .contentKor(createAiTaleReq.getContentKor())
                .image(createAiTaleReq.getImage())
                .wordList(wordList)
                .build();
        aiTaleRepository.save(aiTale);
        CreateAiTaleRes createAiTaleRes = new CreateAiTaleRes(aiTale.getAiTaleId(), aiTale.getWordList().getWordListId(), aiTale.getContentEng(), aiTale.getContentKor(), aiTale.getImage());
        return createAiTaleRes;
    }

    public GetAiTaleRes getAiTale(String wordName, int userId) {
        //유저 있는지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //단어장 인덱스 조회
        WordList wordList = wordListRepository.findByUser_UserIdAndWord_WordEng(user.getUserId(), wordName).orElseThrow(WordListNotFoundException::new);
        //해당 단어로 만들어진 동화가 있는지 확인 -> 동화 조회해서 단어장 인덱스의 유저가 나인지 확인
        AiTale aiTale = aiTaleRepository.findByWordList(wordList).orElseThrow(AiTaleNotFoundException::new);
        if (aiTale.getWordList().getUser().getUserId() != userId)
            throw new BadAccessException();
        GetAiTaleRes getAiTaleRes = GetAiTaleRes.builder()
                .aiTaleId(aiTale.getAiTaleId())
                .wordEng(aiTale.getWordList().getWord().getWordEng())
                .wordKor(aiTale.getWordList().getWord().getWordKor())
                .contentEng(aiTale.getContentEng())
                .contentKor(aiTale.getContentKor())
                .image(aiTale.getImage())
                .build();
        return getAiTaleRes;
    }

    public UpdateAiTaleRes updateAiTale(int aiTaleId, String image, int userId) throws IOException {
        //그 동화가 유저가 쓴게 맞는지 확인 -> 동화 조회해서 단어장 인덱스의 유저가 나인지 확인
        AiTale aiTale = aiTaleRepository.findById(aiTaleId).orElseThrow(AiTaleNotFoundException::new);
        if (aiTale.getWordList().getUser().getUserId() != userId)
            throw new BadAccessException();
        //유저가 선택한 이미지가 있다면 추가한다.
        if (image!=null) {
            String imageUrl = bucketUrl + awsS3Service.uploadImage(image);
            aiTale.setImage(imageUrl);
        }
        aiTaleRepository.save(aiTale);
        UpdateAiTaleRes updateAiTaleRes = new UpdateAiTaleRes(
            aiTale.getAiTaleId(),
            aiTale.getWordList().getWordListId(),
            aiTale.getContentEng(),
            aiTale.getContentKor(),
                aiTale.getImage()
        );
        return updateAiTaleRes;
    }

    public DeleteAiTaleRes deleteAiTale(int aiTaleId, int userId) {
        //그 동화가 유저가 쓴게 맞는지 확인 -> 동화 조회해서 단어장 인덱스의 유저가 나인지 확인
        AiTale aiTale = aiTaleRepository.findById(aiTaleId).orElseThrow(AiTaleNotFoundException::new);
        if (aiTale.getWordList().getUser().getUserId() != userId)
            throw new BadAccessException();
        //동화 이미지가 있다면, 이미지 먼저 삭제
        if (aiTale.getImage() != null) {
            String []temp = aiTale.getImage().split("/");
            String imageName = temp[temp.length-1];
            awsS3Service.deleteImage(imageName);
        }
        //유저 일치여부 확인 후 삭제 수행
        aiTaleRepository.deleteById((aiTale.getAiTaleId()));
        DeleteAiTaleRes deleteAiTaleRes = new DeleteAiTaleRes(aiTale.getAiTaleId());
        return deleteAiTaleRes;
    }
}
