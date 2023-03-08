package com.ssafy.snapstory.domain.quizTaleItemDraw;

import com.ssafy.snapstory.domain.Base;
import com.ssafy.snapstory.domain.quizTaleItem.QuizTaleItem;
import com.ssafy.snapstory.domain.user.User;
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
public class QuizTaleItemDraw extends Base {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int quizTaleItemDrawId;

    @ManyToOne
    @JoinColumn(name="quizTaleItemId")
    private QuizTaleItem quizTaleItem;

    @ManyToOne
    @JoinColumn(name="userId")
    private User user;
}
