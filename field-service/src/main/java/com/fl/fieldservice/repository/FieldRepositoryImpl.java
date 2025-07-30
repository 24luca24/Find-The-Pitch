package com.fl.fieldservice.repository;

import com.fl.fieldservice.dto.FieldUpdateDto;
import com.fl.fieldservice.entity.Field;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
@Transactional
public class FieldRepositoryImpl implements FieldRepositoryCustom {

    @PersistenceContext
    private EntityManager em;

    @Override
    public Optional<Field> updateField(Long id, FieldUpdateDto dto) {
        Field field = em.find(Field.class, id);

        if(field == null){
            return Optional.empty();
        }

        if (dto.getName() != null) field.setName(dto.getName());
        if (dto.getDescription() != null) field.setDescription(dto.getDescription());
        if (dto.getCity() != null) field.setCity(dto.getCity());
        if (dto.getAddress() != null) field.setAddress(dto.getAddress());
        if (dto.getPhone() != null) field.setPhone(dto.getPhone());
        if (dto.getEmail() != null) field.setEmail(dto.getEmail());
        if (dto.getWebsite() != null) field.setWebsite(dto.getWebsite());

        if (dto.getCanShower() != null) field.setCanShower(dto.getCanShower());
        if (dto.getHasParking() != null) field.setHasParking(dto.getHasParking());
        if (dto.getHasLighting() != null) field.setHasLighting(dto.getHasLighting());
        if (dto.getFree() != null) field.setIsFree(dto.getFree());

        if (dto.getOpeningTime() != null) field.setOpeningTime(dto.getOpeningTime());
        if (dto.getLunchBrakeStart() != null) field.setLunchBrakeStart(dto.getLunchBrakeStart());
        if (dto.getLunchBrakeEnd() != null) field.setLunchBrakeEnd(dto.getLunchBrakeEnd());
        if (dto.getClosingTime() != null) field.setClosingTime(dto.getClosingTime());

        if (dto.getPrice() != null) field.setPrice(dto.getPrice());
        if (dto.getSurfaceType() != null) field.setSurfaceType(dto.getSurfaceType());
        if (dto.getPitchType() != null) field.setPitchType(dto.getPitchType());
        if (dto.getAreaType() != null) field.setAreaType(dto.getAreaType());

        return Optional.of(field);
    }
}
