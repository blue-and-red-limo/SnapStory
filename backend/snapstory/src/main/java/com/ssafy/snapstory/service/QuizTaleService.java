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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuizTaleService {
    private final QuizTaleRepository quizTaleRepository;
    private final QuizTaleListRepository quizTaleListRepository;
    private final UserRepository userRepository;

    public List<QuizTale> getQuizTalesIncomplete(int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //퀴즈 동화 중 완성된 퀴즈 동화 리스트에 없는 동화만 리스트로 반환
        List<QuizTale> quizTaleIncomplete = quizTaleRepository.findAll()
                .stream()
                .filter(quizTale ->
                        quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(user.getUserId(), quizTale.getQuizTaleId()).isEmpty())
                .collect(Collectors.toList());
        return quizTaleIncomplete;
    }

    public List<QuizTale> getQuizTalesComplete(int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        //퀴즈 동화 중 완성된 퀴즈 동화 리스트에 있는 동화만 리스트로 반환
        List<QuizTale> quizTaleComplete = quizTaleRepository.findAll()
                .stream()
                .filter(quizTale ->
                        quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(user.getUserId(), quizTale.getQuizTaleId()).isPresent())
                .collect(Collectors.toList());
        return quizTaleComplete;
    }
}
