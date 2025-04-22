package itu.project.aeroport.model.avion;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="type_siege")
public class TypeSiege {
    @Id
    String id_type_siege;

    String designation;

    public String getId_type_siege() {
        return id_type_siege;
    }

    public void setId_type_siege(String id_type_siege) {
        this.id_type_siege = id_type_siege;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }
}
