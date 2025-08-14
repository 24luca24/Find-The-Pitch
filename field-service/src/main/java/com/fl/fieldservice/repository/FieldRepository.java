package com.fl.fieldservice.repository;

import com.fl.fieldservice.dto.FieldUpdateDto;
import com.fl.fieldservice.entity.Field;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

//"I want to get or save data, not how — just let Spring handle it."

@Repository
public interface FieldRepository extends JpaRepository<Field, Long>, FieldRepositoryCustom {

    Optional<Field> findByNameAndCityAndAddress(String fieldName, String city, String address);

    //To be used when I load the map screen (See frontend package)
    Optional<Field> findAllByCity(String city);

    //To be used in the filter
    Optional<Field> findByNameStartingWith(String fieldName);

    //To be used after creation of a field. I want the map screen to show that specific field
    Optional<Field> findOneByName(String fieldName);


}
