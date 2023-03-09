package com.ssafy.snapstory.domain.word;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class Word {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int wordId;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordKor;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExplanationEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExplanationKor;

    @Column(columnDefinition = "varchar(255) default null")
    private String wordSound;

    @Column(columnDefinition = "varchar(255) default null")
    private String wordExplanationSound;
}
