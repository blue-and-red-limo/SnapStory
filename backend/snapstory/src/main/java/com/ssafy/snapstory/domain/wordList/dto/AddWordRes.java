package com.ssafy.snapstory.domain.wordList.dto;

import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.word.Word;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AddWordRes {
    private String wordExampleEng;
    private String wordExampleKor;
    private String wordExampleSound;
    private Word word;
    private User user;
}
