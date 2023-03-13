package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.domain.quizTaleItemList.QuizTaleItemList;
import com.ssafy.snapstory.domain.quizTaleItemList.dto.DrawQuizTaleItem;
import com.ssafy.snapstory.domain.quizTaleItemList.dto.DrawQuizTaleItemList;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.exception.not_found.QuizTaleNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class QuizTaleItemListService {
    private final QuizTaleItemListRepository quizTaleItemListRepository;
    private final QuizTaleItemDrawRepository quizTaleItemDrawRepository;
    private final QuizTaleRepository quizTaleRepository;
    private final UserRepository userRepository;

    public DrawQuizTaleItemList getDrawQuizTaleItemList(int quizTaleId, int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        // 해당 동화가 유효한지 확인
        QuizTale quizTale = quizTaleRepository.findById(quizTaleId).orElseThrow(QuizTaleNotFoundException::new);
        // 해당 퀴즈 동화에 속해있는 퀴즈 동화 아이템들 가져오기
        List<QuizTaleItemList> quizTaleItemLists = quizTaleItemListRepository.findAllByQuizTale(quizTale);
        // 퀴즈 동화 아이템별로 성공 여부를 반환하기 위한 새로운 리스트 생성
        List<DrawQuizTaleItem> drawQuizTaleItems = new ArrayList<>();
        for (QuizTaleItemList quizTaleItemList : quizTaleItemLists) {
            drawQuizTaleItems.add(new DrawQuizTaleItem(
                quizTaleItemList.getQuizTaleItemListId(),
                quizTaleItemList.getQuizTaleItem().getItemEng(),
                quizTaleItemList.getQuizTaleItem().getItemKor(),
                // 퀴즈 성공 여부
                quizTaleItemDrawRepository.findByUserAndQuizTaleItemList(user, quizTaleItemList).isPresent()
            ));
        }
        // 퀴즈 성공 여부가 포함된 해당 퀴즈 동화의 퀴즈 동화 아이템 리스트 반환
        DrawQuizTaleItemList drawQuizTaleItemList = new DrawQuizTaleItemList(
            // 유저 정보
            user.getUserId(),
            // 퀴즈 동화 정보
            quizTale.getQuizTaleId(),
            // 성공 여부가 포함된 퀴즈 동화 아이템 리스트
            drawQuizTaleItems
        );
        return drawQuizTaleItemList;
    }
}
