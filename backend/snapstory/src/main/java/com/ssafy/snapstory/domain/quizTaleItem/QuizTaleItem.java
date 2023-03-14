package com.ssafy.snapstory.domain.quizTaleItem;

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
public class QuizTaleItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int quizTaleItemId;

    @Column(columnDefinition = "varchar(255) not null")
    private String itemEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String imageBlack;

    @Column(columnDefinition = "varchar(255) not null")
    private String imageColor;
}
