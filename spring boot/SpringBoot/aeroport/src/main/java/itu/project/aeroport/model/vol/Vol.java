package itu.project.aeroport.model.vol;

import java.sql.Timestamp;
import java.time.Duration;

import itu.project.aeroport.component.DurationAttributeConverter;
import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name="vol")
public class Vol {
    @Id
    String id_vol;

    @ManyToOne
    @JoinColumn(name="depart",nullable = false)
    Ville depart;

    Timestamp date_depart;

    @Column(name = "duree_vol", columnDefinition = "INTERVAL")
    @Convert(converter = DurationAttributeConverter.class)
    Duration duree_vol;

    @ManyToOne
    @JoinColumn(name="destination",nullable = false)
    Ville destination;

    public String getId_vol() {
        return id_vol;
    }

    public void setId_vol(String id_vol) {
        this.id_vol = id_vol;
    }

    public Ville getDepart() {
        return depart;
    }

    public void setDepart(Ville depart) {
        this.depart = depart;
    }

    public Timestamp getDate_depart() {
        return date_depart;
    }

    public void setDate_depart(Timestamp date_depart) {
        this.date_depart = date_depart;
    }

    public Duration getDuree_vol() {
        return duree_vol;
    }

    public void setDuree_vol(Duration duree_vol) {
        this.duree_vol = duree_vol;
    }

    public void setDureeFormatted(String duree){
        String[] parts = duree.split(":");
        this.duree_vol = Duration.ofHours(Integer.parseInt(parts[0])).plusMinutes(Integer.parseInt(parts[1])).plusSeconds(Integer.parseInt(parts[3]));
    }

    public String getDureeFormatted(){
        return String.format("%02d:%02d:%02d",duree_vol.toHours(),duree_vol.toMinutesPart(),duree_vol.toSecondsPart());
    }

    public Ville getDestination() {
        return destination;
    }

    public void setDestination(Ville destination) {
        this.destination = destination;
    }

}
