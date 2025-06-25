package com.fl.fieldservice.service;

import com.fl.fieldservice.repository.FieldRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

//Handle logic, like verifying if a field is already saved when trying to save it

@Service
public class FieldService {

    @Autowired
    private FieldRepository fieldRepository;


}
