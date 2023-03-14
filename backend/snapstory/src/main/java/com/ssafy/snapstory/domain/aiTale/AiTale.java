package com.ssafy.snapstory.domain.aiTale;

import com.ssafy.snapstory.domain.Base;
import com.ssafy.snapstory.domain.wordList.WordList;
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
public class AiTale extends Base {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int aiTaleId;

    @Column(columnDefinition = "varchar(255) not null")
    private String contentEng;

    @Column(columnDefinition = "varchar(255) not null")
    private String contentKor;

    @Column(columnDefinition = "varchar(255) default null")
    private String image;

    @ManyToOne
    @JoinColumn(name="wordListId")
    private WordList wordList;
}
