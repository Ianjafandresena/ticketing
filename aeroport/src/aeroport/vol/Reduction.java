package aeroport.vol;

import java.sql.Timestamp;

import aeroport.reservation.Reservation;
import mg.itu.annotation.type.DateSQL;
import mg.itu.annotation.type.Numeric;
import mg.itu.annotation.type.Text;
import utility.Entity;
import utility.annotation.Column;
import utility.annotation.Table;

@Table(name="reduction")
public class Reduction extends Entity<Reservation>{
    @Column(name="id_reduction")
    @Numeric
    Integer idReduction;

    @Numeric
    Double pourcentage;

    @Column(name="id_categorie_passager")
    @Text
    String idCategoriePassager;

    @DateSQL(type="timestamp",format = "yyyy-MM-dd HH:mm:ss")
    @Column(name="date_application")
    Timestamp dateApplication;

    public Integer getIdReduction() {
        return idReduction;
    }

    public void setIdReduction(Integer idReduction) {
        this.idReduction = idReduction;
    }

    public Double getPourcentage() {
        return pourcentage;
    }

    public void setPourcentage(Double pourcentage) {
        this.pourcentage = pourcentage;
    }

    public String getIdCategoriePassager() {
        return idCategoriePassager;
    }

    public void setIdCategoriePassager(String idCategoriePassager) {
        this.idCategoriePassager = idCategoriePassager;
    }

    public Timestamp getDateApplication() {
        return dateApplication;
    }

    public void setDateApplication(Timestamp dateApplication) {
        this.dateApplication = dateApplication;
    }

    public Reduction(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }



}
