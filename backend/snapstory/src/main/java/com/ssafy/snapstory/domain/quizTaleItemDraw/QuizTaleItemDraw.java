package com.ssafy.snapstory.domain.quizTaleItemDraw;

import com.ssafy.snapstory.domain.Base;
import com.ssafy.snapstory.domain.quizTaleItem.QuizTaleItem;
import com.ssafy.snapstory.domain.user.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class QuizTaleItemDraw extends Base {
    @Id
    private int quizTaleItemDrawId;

    @ManyToOne
    @JoinColumn(name="quizTaleItemId")
    private QuizTaleItem quizTaleItem;

    @ManyToOne
    @JoinColumn(name="userId")
    private User user;
}
