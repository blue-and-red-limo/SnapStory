package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.repository.QuizTaleListRepository;
import com.ssafy.snapstory.repository.QuizTaleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuizTaleService {
    private final QuizTaleRepository quizTaleRepository;
    private final QuizTaleListRepository quizTaleListRepository;

    public List<QuizTale> getQuizTalesIncomplete(int userId) {
        List quizTaleIncomplete = quizTaleRepository.findAll()
                .stream()
                .filter(quizTale ->
                        quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(userId, quizTale.getQuizTaleId()).isEmpty())
                .collect(Collectors.toList());
        return quizTaleIncomplete;
    }

    public List<QuizTale> getQuizTalesComplete(int userId) {
        List quizTaleComplete = quizTaleRepository.findAll()
                .stream()
                .filter(quizTale ->
                        quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(userId, quizTale.getQuizTaleId()).isPresent())
                .collect(Collectors.toList());
        return quizTaleComplete;
    }
}
