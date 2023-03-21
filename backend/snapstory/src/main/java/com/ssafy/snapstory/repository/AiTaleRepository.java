package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.aiTale.AiTale;
import com.ssafy.snapstory.domain.wordList.WordList;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AiTaleRepository extends JpaRepository<AiTale, Integer> {
    Optional<AiTale> findByWordList(WordList wordList);
}
