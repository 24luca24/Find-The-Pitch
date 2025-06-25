package com.fl.fieldservice.entity;

import jakarta.persistence.*;

@Entity
public class Image {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Lob
    private byte[] data;

    @ManyToOne
    @JoinColumn(name = "field_id")
    private Field field;

    //Constructors
    public Image() {}

    public Image(byte[] data, Field field) {
        this.data = data;
        this.field = field;
    }

    //Getter and Setter

    //ID
    private void setId(Long id) {
        this.id = id;
    }
    public Long getId() {
        return id;
    }

    //DATA
    private void setData(byte[] data) {
        this.data = data;
    }
    public byte[] getData() {
        return data;
    }

    //FIELD
    private void setField(Field field) {
        this.field = field;
    }
    public Field getField() {
        return field;
    }
}
