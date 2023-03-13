package com.ssafy.snapstory.domain.quizTaleItemDraw.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DrawQuizTaleItemRes {
    private int userId;
    private int quizTaleId;
    private int quizTaleItemListId;
    private boolean complete;
}
