package com.ssafy.snapstory.domain.quizTaleList.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AddQuizTaleListReq {
    private int quizTaleId;
}
