package com.ssafy.snapstory.domain.quizTaleItemList.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DrawQuizTaleItem {
    private int itemId;
    private String itemEng;
    private String imageBlack;
    private String imageColor;
    private boolean draw;
}
