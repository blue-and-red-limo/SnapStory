package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.wordList.WordList;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WordListRepository extends JpaRepository<WordList, Integer> {
    Optional<List<WordList>> findAllByUser(User user);
}
