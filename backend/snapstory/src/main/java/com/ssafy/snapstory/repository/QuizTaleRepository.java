package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuizTaleRepository extends JpaRepository<QuizTale, Integer> {
}
