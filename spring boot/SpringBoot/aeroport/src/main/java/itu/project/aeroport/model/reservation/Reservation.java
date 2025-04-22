package itu.project.aeroport.model.reservation;

import java.sql.Timestamp;

import itu.project.aeroport.model.avion.TypeSiege;
import itu.project.aeroport.model.vol.Vol;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name="reservation")
public class Reservation {
    @Id
    String id_reservation;

    @ManyToOne
    @JoinColumn(name="id_type_siege",nullable = false)
    TypeSiege id_type_siege;

    int nb_enfant;
    int nb_adulte;

    double prix;

    @ManyToOne
    @JoinColumn(name="id_client",nullable = true)
    Client client;

    Timestamp date_reservation;

    @ManyToOne
    @JoinColumn(name="id_vol",nullable = false)
    Vol vol;

    public Vol getVol() {
        return vol;
    }

    public void setVol(Vol vol) {
        this.vol = vol;
    }

    public String getId_reservation() {
        return id_reservation;
    }

    public void setId_reservation(String id_reservation) {
        this.id_reservation = id_reservation;
    }

    public TypeSiege getId_type_siege() {
        return id_type_siege;
    }

    public void setId_type_siege(TypeSiege id_type_siege) {
        this.id_type_siege = id_type_siege;
    }

    public int getNb_enfant() {
        return nb_enfant;
    }

    public void setNb_enfant(int nb_enfant) {
        this.nb_enfant = nb_enfant;
    }

    public int getNb_adulte() {
        return nb_adulte;
    }

    public void setNb_adulte(int nb_adulte) {
        this.nb_adulte = nb_adulte;
    }

    public double getPrix() {
        return prix;
    }

    public void setPrix(double prix) {
        this.prix = prix;
    }

    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        this.client = client;
    }

    public Timestamp getDate_reservation() {
        return date_reservation;
    }

    public void setDate_reservation(Timestamp date_reservation) {
        this.date_reservation = date_reservation;
    }

    


}
