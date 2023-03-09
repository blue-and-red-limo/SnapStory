package com.ssafy.snapstory.domain.wordList;

import com.ssafy.snapstory.domain.Base;
import com.ssafy.snapstory.domain.user.User;
import com.ssafy.snapstory.domain.word.Word;
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
public class WordList extends Base {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int wordListId;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExampleEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String wordExampleKor;

    @Column(columnDefinition = "varchar(255) default null")
    private String wordExampleSound;

    @ManyToOne
    @JoinColumn(name="userId")
    private User user;

    @ManyToOne
    @JoinColumn(name="wordId")
    private Word word;
}
