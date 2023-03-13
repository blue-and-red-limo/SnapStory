package com.ssafy.snapstory.domain.quizTale;

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
public class QuizTale {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int quizTaleId;

    @Column(columnDefinition = "varchar(255) not null")
    private String title;

    @Column(columnDefinition = "varchar(255) not null")
    private String video;
}
