package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.quizTaleItemDraw.QuizTaleItemDraw;
import com.ssafy.snapstory.domain.quizTaleItemList.QuizTaleItemList;
import com.ssafy.snapstory.domain.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface QuizTaleItemDrawRepository extends JpaRepository<QuizTaleItemDraw, Integer> {
    Optional<QuizTaleItemDraw> findByUserAndQuizTaleItemList(User user, QuizTaleItemList quizTaleItemList);
}
