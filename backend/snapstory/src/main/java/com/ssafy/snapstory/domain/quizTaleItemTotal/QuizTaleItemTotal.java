package com.ssafy.snapstory.domain.quizTaleItemTotal;

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
public class QuizTaleItemTotal {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int quizTaleItemTotalId;

    @Column(columnDefinition = "varchar(255) not null")
    private String itemNameEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String itemNameKor;
}
