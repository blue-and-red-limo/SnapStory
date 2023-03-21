package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.word.Word;
import com.ssafy.snapstory.domain.wordList.WordList;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface WordRepository extends JpaRepository<Word, Integer> {
    Optional<Word> findByWordEng(String wordEng);

}
