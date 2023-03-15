package com.ssafy.snapstory.service;

import com.ssafy.snapstory.domain.quizTaleItemDraw.QuizTaleItemDraw;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemReq;
import com.ssafy.snapstory.domain.quizTaleItemDraw.dto.DrawQuizTaleItemRes;
import com.ssafy.snapstory.domain.quizTaleItemList.QuizTaleItemList;
import com.ssafy.snapstory.domain.quizTaleList.QuizTaleList;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.exception.conflict.QuizTaleItemListDuplicateException;
import com.ssafy.snapstory.exception.not_found.QuizTaleItemListNotFoundException;
import com.ssafy.snapstory.exception.not_found.UserNotFoundException;
import com.ssafy.snapstory.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class QuizTaleItemDrawService {
    private final QuizTaleItemListRepository quizTaleItemListRepository;
    private final QuizTaleItemDrawRepository quizTaleItemDrawRepository;
    private final UserRepository userRepository;
    private final QuizTaleListService quizTaleListService;
    private final QuizTaleListRepository quizTaleListRepository;

    public DrawQuizTaleItemRes drawQuizTaleItem(DrawQuizTaleItemReq drawQuizTaleItemReq, int userId) {
        // 유저 상태가 유효한지 확인
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        // 해당 퀴즈 동화의 아이템 리스트 확인
        QuizTaleItemList quizTaleItemList = quizTaleItemListRepository.findById(drawQuizTaleItemReq.getQuizTaleItemListId()).orElseThrow(QuizTaleItemListNotFoundException::new);
        // 해당 퀴즈 동화의 기존 성공 여부 확인
        Optional<QuizTaleList> quizTaleList = quizTaleListRepository.findByUser_UserIdAndQuizTale_QuizTaleId(userId, quizTaleItemList.getQuizTale().getQuizTaleId());
        // 성공 여부를 확인/수정할 완성된 퀴즈 동화 아이템 리스트 불러오기
        Optional<QuizTaleItemDraw> quizTaleItemDraw = quizTaleItemDrawRepository.findByUserAndQuizTaleItemList(user, quizTaleItemList);
        DrawQuizTaleItemRes drawQuizTaleItemRes;
        // 완성된 퀴즈 동화 아이템 리스트에 없는 경우 추가
        if (quizTaleItemDraw.isEmpty()) {
            QuizTaleItemDraw newQuizTaleItemDraw = QuizTaleItemDraw.builder()
                    .quizTaleItemList(quizTaleItemList)
                    .user(user)
                    .build();
            quizTaleItemDrawRepository.save(newQuizTaleItemDraw);
            drawQuizTaleItemRes = new DrawQuizTaleItemRes(
                    newQuizTaleItemDraw.getUser().getUserId(),
                    newQuizTaleItemDraw.getQuizTaleItemList().getQuizTale().getQuizTaleId(),
                    drawQuizTaleItemReq.getQuizTaleItemListId(),
                    // 해당 동화의 기존 성공 여부
                    quizTaleList.isPresent()
            );
        } else {
            // 완성된 퀴즈 동화 아이템 리스트에 있는 경우
            throw new QuizTaleItemListDuplicateException();
        }

        // 퀴즈 동화 완성 여부 반환을 위한 해당 동화 아이템 리스트 조히
        List<QuizTaleItemList> qtlist = quizTaleItemListRepository.findAllByQuizTale_QuizTaleId(drawQuizTaleItemRes.getQuizTaleId());
        // 완성 아이템 갯수 카운트
        int cnt = 0;
        for (QuizTaleItemList qt : qtlist) {
            // 동화 아이템이 완성된 동화 아이템 리스트에 있으면 카운트
            Optional<QuizTaleItemDraw> tmp = quizTaleItemDrawRepository.findByUserAndQuizTaleItemList(user, qt);
            if (tmp.isPresent()) cnt++;
        }
        // 완성한 동화 아이템 갯수와 동화에 필요한 아이템 갯수가 같으면(아이템을 전부 다 그렸으면) 성공
        if (cnt == qtlist.size()) {
            // 해당 동화를 기존에 성공한 적이 없으면
            if (quizTaleList.isEmpty()) {
                // 완성된 동화 리스트에 추가
                quizTaleListService.addQuizTaleList(drawQuizTaleItemRes.getQuizTaleId(), userId);
                // 동화 완성 여부 true로 변경
                drawQuizTaleItemRes.setComplete(true);
            }
            // 개별 동화 아이템별로 완성 여부 초기화(다시 그릴 수 있게)
            for (QuizTaleItemList qt : qtlist) {
                quizTaleItemDrawRepository.deleteByQuizTaleItemList(qt);
            }
        }
        return drawQuizTaleItemRes;
    }
}
