package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.quizTaleList.QuizTaleList;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface QuizTaleListRepository extends JpaRepository<QuizTaleList, Integer> {
    Optional<QuizTaleList> findByUser_UserIdAndQuizTale_QuizTaleId (int userId, int quizTaleId);
}
