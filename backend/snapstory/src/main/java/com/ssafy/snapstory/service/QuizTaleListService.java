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

    public AddQuizTaleListRes addQuizTaleList(int quizTaleId, int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        // 퀴즈 동화가 해당 유저의 완성된 퀴즈 동화 리스트에 있는지 확인
        Optional<QuizTaleList> quizTaleList = quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(user.getUserId(), quizTaleId);
        AddQuizTaleListRes addQuizTaleListRes = new AddQuizTaleListRes();
        if (quizTaleList.isEmpty()) {
            // 해당 동화가 유효한지 확인
            QuizTale quizTale = quizTaleRepository.findById(quizTaleId).orElseThrow(QuizTaleNotFoundException::new);
            // 완성된 퀴즈 동화에 추가(생성)
            QuizTaleList newQuizTaleList = QuizTaleList.builder()
                    .quizTale(quizTale)
                    .user(user)
                    .build();
            quizTaleListRepository.save(newQuizTaleList);
            addQuizTaleListRes.setQuizTaleListId(newQuizTaleList.getQuizTaleListId());
            addQuizTaleListRes.setQuizTale(newQuizTaleList.getQuizTale());
            addQuizTaleListRes.setUser(newQuizTaleList.getUser());
//        } else {
//            // 이미 완성된 퀴즈 동화 리스트에 있는 경우
//            throw new QuizTaleDuplicateException();
        }
        return addQuizTaleListRes;
    }
}
