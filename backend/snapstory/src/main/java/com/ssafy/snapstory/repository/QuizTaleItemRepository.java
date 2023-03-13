package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.quizTaleItem.QuizTaleItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuizTaleItemRepository extends JpaRepository<QuizTaleItem, Integer> {
}
