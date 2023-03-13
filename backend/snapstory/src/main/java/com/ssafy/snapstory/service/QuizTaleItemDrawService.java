package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.quizTaleItemDraw.QuizTaleItemDraw;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemReq;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemRes;
import com.ssafy.snapstory.domain.quizTaleItemList.QuizTaleItemList;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.exception.conflict.QuizTaleItemListDuplicateException;
import com.ssafy.snapstory.exception.not_found.QuizTaleItemListNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.repository.QuizTaleItemDrawRepository;
import com.ssafy.snapstory.repository.QuizTaleItemListRepository;
import com.ssafy.snapstory.repository.QuizTaleRepository;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class QuizTaleItemDrawService {
    private final QuizTaleItemListRepository quizTaleItemListRepository;
    private final QuizTaleItemDrawRepository quizTaleItemDrawRepository;
    private final QuizTaleRepository quizTaleRepository;
    private final UserRepository userRepository;

    public DrawQuizTaleItemRes drawQuizTaleItem(DrawQuizTaleItemReq drawQuizTaleItemReq, int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        // 해당 퀴즈 동화의 아이템 리스트 확인
        QuizTaleItemList quizTaleItemList = quizTaleItemListRepository.findById(drawQuizTaleItemReq.getQuizTaleItemListId()).orElseThrow(QuizTaleItemListNotFoundException::new);
        // 성공 여부를 확인/수정할 완성된 퀴즈 동화 아이템 리스트 불러오기
        Optional<QuizTaleItemDraw> quizTaleItemDraw = quizTaleItemDrawRepository.findByUserAndQuizTaleItemList(user, quizTaleItemList);
        DrawQuizTaleItemRes drawQuizTaleItemRes;
        // 완성된 퀴즈 동화 아이템 리스트에 없는 경우 추가
        if (quizTaleItemDraw.isEmpty()) {
            QuizTaleItemDraw newQuizTaleItemDraw = QuizTaleItemDraw.builder()
                    .quizTaleItemList(quizTaleItemList)
                    .user(user)
                    .build();
            quizTaleItemDrawRepository.save(newQuizTaleItemDraw);
            drawQuizTaleItemRes = new DrawQuizTaleItemRes(
                    newQuizTaleItemDraw.getUser().getUserId(),
                    newQuizTaleItemDraw.getQuizTaleItemList().getQuizTale().getQuizTaleId(),
                    drawQuizTaleItemReq.getQuizTaleItemListId()
            );
        } else {
            // 완성된 퀴즈 동화 아이템 리스트에 있는 경우
            throw new QuizTaleItemListDuplicateException();
        }


        return drawQuizTaleItemRes;
    }
}
