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
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        QuizTaleItemList quizTaleItemList = quizTaleItemListRepository.findById(drawQuizTaleItemReq.getQuizTaleItemListId()).orElseThrow(QuizTaleItemListNotFoundException::new);
        Optional<QuizTaleItemDraw> quizTaleItemDraw = quizTaleItemDrawRepository.findByUserAndQuizTaleItemList(user, quizTaleItemList);
        DrawQuizTaleItemRes drawQuizTaleItemRes;
        if (quizTaleItemDraw.isEmpty()) {
            QuizTaleItemDraw newQuizTaleItemDraw = QuizTaleItemDraw.builder()
                    .quizTaleItemList(quizTaleItemList)
                    .user(user)
                    .build();
            quizTaleItemDrawRepository.save(newQuizTaleItemDraw);
            drawQuizTaleItemRes = new DrawQuizTaleItemRes(
                    newQuizTaleItemDraw.getUser().getUserId(),
                    newQuizTaleItemDraw.getQuizTaleItemList().getQuizTale().getQuizTaleId(),
                    newQuizTaleItemDraw.getQuizTaleItemDrawId()
            );
        } else {
            throw new QuizTaleItemListDuplicateException();
        }
        return drawQuizTaleItemRes;
    }
}
