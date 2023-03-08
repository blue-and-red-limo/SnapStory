package com.ssafy.snapstory.domain.quizTaleItem;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.domain.quizTaleItemTotal.QuizTaleItemTotal;
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

    @ManyToOne
    @JoinColumn(name="quizTaleId")
    private QuizTale quizTale;

    @ManyToOne
    @JoinColumn(name="quizTaleItemTotalId")
    private QuizTaleItemTotal quizTaleItemTotal;
}
