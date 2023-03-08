package com.ssafy.snapstory.domain.quizTale;

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
public class QuizTale {
    @Id
    private int quizTaleId;

    @Column(columnDefinition = "varchar(255) not null")
    private String title;

    @Column(columnDefinition = "varchar(255) not null")
    private String video;
}
