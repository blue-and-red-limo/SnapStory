package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.wordList.WordList;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WordListRepository extends JpaRepository<WordList, Integer> {
    List<WordList> findAllByUser(User user);
    List<WordList> findAllByUser_UserId(int userId);
    Optional<WordList> findByUser_UserIdAndWordListId(int userId, int wordListId);
    Optional<WordList> findByWord_WordId(int wordId);
}
