package com.ssafy.snapstory.domain.user;

import com.ssafy.snapstory.domain.Base;
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
public class User extends Base {
    @Id
    private int userId;

    @Column(columnDefinition = "varchar(255) not null")
    private String email;

    @Column(columnDefinition = "varchar(255) not null")
    private String name;
}
