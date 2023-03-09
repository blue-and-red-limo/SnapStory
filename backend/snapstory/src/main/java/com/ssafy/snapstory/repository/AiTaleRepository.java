package com.ssafy.snapstory.repository;

import com.ssafy.snapstory.domain.aiTale.AiTale;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AiTaleRepository extends JpaRepository<AiTale, Integer> {
}
