package itu.project.aeroport.model.vol;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ville")
public class Ville {
    @Id
    String id_ville;
    String designation;
    public String getId_ville() {
        return id_ville;
    }
    public void setId_ville(String id_ville) {
        this.id_ville = id_ville;
    }
    public String getDesignation() {
        return designation;
    }
    public void setDesignation(String designation) {
        this.designation = designation;
    }
}
