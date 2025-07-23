package com.fl.fieldservice.repository;

import com.fl.fieldservice.dto.FieldUpdateDto;
import com.fl.fieldservice.entity.Field;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

//"I want to get or save data, not how — just let Spring handle it."

@Repository
public interface FieldRepository extends JpaRepository<Field, Long> {

    Optional<Field> findByNameCityAddress(String fieldName, String city, String address);

    Optional<Long> updateField(Long id, FieldUpdateDto dto);

}
