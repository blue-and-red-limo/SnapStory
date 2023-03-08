package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.wordList.WordList;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WordListRepository extends JpaRepository<WordList, Integer> {

}
