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
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        QuizTale quizTale = quizTaleRepository.findById(quizTaleId).orElseThrow(QuizTaleNotFoundException::new);
        List<QuizTaleItemList> quizTaleItemLists = quizTaleItemListRepository.findAllByQuizTale(quizTale);
        List<DrawQuizTaleItem> drawQuizTaleItems = new ArrayList<>();
        for (QuizTaleItemList quizTaleItemList : quizTaleItemLists) {
            drawQuizTaleItems.add(new DrawQuizTaleItem(
                quizTaleItemList.getQuizTaleItemListId(),
                quizTaleItemList.getQuizTaleItem().getItemEng(),
                quizTaleItemList.getQuizTaleItem().getItemKor(),
                quizTaleItemDrawRepository.findByUserAndQuizTaleItemList(user, quizTaleItemList).isPresent()
            ));
        }
        DrawQuizTaleItemList drawQuizTaleItemList = new DrawQuizTaleItemList(
            user.getUserId(),
            quizTale.getQuizTaleId(),
            drawQuizTaleItems
        );
        return drawQuizTaleItemList;
    }
}
