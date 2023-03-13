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
    private int wordListId;
    private String contentEng;

    private String contentKor;

    private String image;

    private String sound;
}
