package com.ssafy.snapstory.domain.word;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class Word {
    @Id
    private int wordId;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordKor;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExplanationEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExplanationKor;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordSound;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExplanationSound;
}
