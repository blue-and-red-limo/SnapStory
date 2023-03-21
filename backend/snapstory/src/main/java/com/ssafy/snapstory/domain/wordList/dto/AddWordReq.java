package com.ssafy.snapstory.domain.wordList.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AddWordReq {
    private String wordExampleEng;
    private String wordExampleKor;
    private String word;
}
