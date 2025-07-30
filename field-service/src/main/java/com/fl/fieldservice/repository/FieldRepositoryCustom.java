package com.fl.fieldservice.repository;

import com.fl.fieldservice.dto.FieldUpdateDto;
import com.fl.fieldservice.entity.Field;

import java.util.Optional;

public interface FieldRepositoryCustom {

    Optional<Field> updateField(Long id, FieldUpdateDto dto);
}
