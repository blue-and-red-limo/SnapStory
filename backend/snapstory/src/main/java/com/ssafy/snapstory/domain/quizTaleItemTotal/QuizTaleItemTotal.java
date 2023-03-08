package com.ssafy.snapstory.domain.quizTaleItemTotal;

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
public class QuizTaleItemTotal {
    @Id
    private int quizTaleItemTotalId;

    @Column(columnDefinition = "varchar(255) not null")
    private String itemNameEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String itemNameKor;
}
