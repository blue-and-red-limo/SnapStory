package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.domain.quizTaleItemList.QuizTaleItemList;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizTaleItemListRepository extends JpaRepository<QuizTaleItemList, Integer> {
    List<QuizTaleItemList> findAllByQuizTale(QuizTale quizTale);
    List<QuizTaleItemList> findAllByQuizTale_QuizTaleId(int quizTaleId);
}
