package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.word.Word;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WordRepository extends JpaRepository<Word, Integer> {

}
