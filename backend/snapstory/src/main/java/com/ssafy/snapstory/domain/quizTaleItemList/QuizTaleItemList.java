package com.ssafy.snapstory.domain.quizTaleItemList;

import com.ssafy.snapstory.domain.quizTale.QuizTale;
import com.ssafy.snapstory.domain.quizTaleItem.QuizTaleItem;
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
public class QuizTaleItemList {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int quizTaleItemListId;

    @ManyToOne
    @JoinColumn(name="quizTaleId")
    private QuizTale quizTale;

    @ManyToOne
    @JoinColumn(name="quizTaleItemId")
    private QuizTaleItem quizTaleItem;
}
