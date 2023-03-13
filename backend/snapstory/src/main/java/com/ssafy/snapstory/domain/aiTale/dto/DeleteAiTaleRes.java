package com.ssafy.snapstory.domain.aiTale.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DeleteAiTaleRes {
    private int aiTaleId;
}

