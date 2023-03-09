package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.domain.quizTaleList.QuizTaleList;
import com.ssafy.snapstory.domain.quizTaleList.dto.AddQuizTaleListReq;
import com.ssafy.snapstory.domain.quizTaleList.dto.AddQuizTaleListRes;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.exception.conflict.QuizTaleDuplicateException;
import com.ssafy.snapstory.exception.not_found.QuizTaleNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.repository.QuizTaleListRepository;
import com.ssafy.snapstory.repository.QuizTaleRepository;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class QuizTaleListService {
    private final QuizTaleListRepository quizTaleListRepository;
    private final QuizTaleRepository quizTaleRepository;
    private final UserRepository userRepository;

    public AddQuizTaleListRes addQuizTaleList(AddQuizTaleListReq addQuizTaleListReq) {
        Optional<QuizTaleList> quizTaleList = quizTaleListRepository.findByQuizTale_QuizTaleId(addQuizTaleListReq.getQuizTaleId());
        AddQuizTaleListRes addQuizTaleListRes;
        if (!quizTaleList.isPresent()) {
            QuizTale quizTale = quizTaleRepository.findById(addQuizTaleListReq.getQuizTaleId()).orElseThrow(QuizTaleNotFoundException::new);
            User user = userRepository.findById(addQuizTaleListReq.getUserId()).orElseThrow(UserNotFoundException::new);
            QuizTaleList newQuizTaleList = QuizTaleList.builder()
                    .quizTale(quizTale)
                    .user(user)
                    .build();
            quizTaleListRepository.save(newQuizTaleList);
            addQuizTaleListRes = new AddQuizTaleListRes(
                    newQuizTaleList.getQuizTaleListId(),
                    newQuizTaleList.getQuizTale(),
                    newQuizTaleList.getUser()
            );
        } else {
            throw new QuizTaleDuplicateException();
        }
        return addQuizTaleListRes;
    }
}
