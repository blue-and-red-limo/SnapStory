package com.ssafy.snapstory.domain.aiTale.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class GetAiTaleRes {
    private int aiTaleId;

    private String wordEng;
    private String wordKor;
    private String contentEng;

    private String contentKor;

    private String image;

}
