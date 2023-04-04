package com.ssafy.snapstory.domain.quizTaleItemList.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DrawQuizTaleItemList {
    private int userid;
    private int quizTaleId;
    private String video;
    private String title;
    private List<DrawQuizTaleItem> drawQuizTaleItems;
}
