package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.repository.QuizTaleListRepository;
import com.ssafy.snapstory.repository.QuizTaleRepository;
import com.ssafy.snapstory.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuizTaleService {
    private final QuizTaleRepository quizTaleRepository;
    private final QuizTaleListRepository quizTaleListRepository;
    private final UserRepository userRepository;

    public List<QuizTale> getQuizTalesIncomplete(String userId) {
            List quizTaleIncomplete = quizTaleRepository.findAll()
                    .stream()
                    .filter(quizTale ->
                            quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(Integer.parseInt(userId), quizTale.getQuizTaleId()).isEmpty())
                    .collect(Collectors.toList());
            return quizTaleIncomplete;
    }

    public List<QuizTale> getQuizTalesComplete(String userId) {
        List quizTaleComplete = quizTaleRepository.findAll()
                .stream()
                .filter(quizTale ->
                        quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(Integer.parseInt(userId), quizTale.getQuizTaleId()).isPresent())
                .collect(Collectors.toList());
        return quizTaleComplete;
    }
}
