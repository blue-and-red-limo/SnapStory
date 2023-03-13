package com.ssafy.snapstory.domain.quizTaleList.dto;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.domain.user.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AddQuizTaleListRes {
    private int quizTaleListId;
    private QuizTale quizTale;
    private User user;
}
