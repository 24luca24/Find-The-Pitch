package com.fl.fieldservice.controller;

import com.fl.fieldservice.repository.FieldRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

//What your mobile app or frontend talks to via HTTP
//Uses the Service layer to return data
//Expose the service logic to the outside world using HTTP

@RestController
@RequestMapping("/api/fields")
public class FieldController {

    @Autowired
    private FieldRepository fieldRepository;
}
