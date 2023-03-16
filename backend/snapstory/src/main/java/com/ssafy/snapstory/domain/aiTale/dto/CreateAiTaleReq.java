package com.ssafy.snapstory.domain.aiTale.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class CreateAiTaleReq {
    private String word;
    private String contentEng;

    private String contentKor;

    private String image;
}
