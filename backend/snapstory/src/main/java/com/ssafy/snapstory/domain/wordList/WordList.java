package com.ssafy.snapstory.domain.wordList;

import com.ssafy.snapstory.domain.Base;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.word.Word;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class WordList extends Base {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int wordListId;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExampleEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExampleKor;

    @ManyToOne
    @OnDelete(action= OnDeleteAction.CASCADE)
    @JoinColumn(name="userId")
    private User user;

    @ManyToOne
    @JoinColumn(name="wordId")
    private Word word;
}
