package aeroport.reservation;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import aeroport.vol.Vol;
import mg.itu.annotation.type.DateSQL;
import mg.itu.annotation.type.Numeric;
import mg.itu.annotation.type.Text;
import utility.Entity;
import utility.annotation.Column;
import utility.annotation.Table;

@Table(name="limit_reservation")
public class LimitReservation extends Entity<LimitReservation>{
    @Column(name="id_limit")
    Integer id_limit_reservation;
    @Column(name="nb_hrs")
    @Numeric
    Double nbHrs;
    @DateSQL(type="timestamp",format = "yyyy-MM-dd HH:mm:ss")
    @Column(name="date_application")
    Timestamp dateApplication;
    @Text
    @Column(name="id_vol")
    String idVol;
    
    public void setIdVol(String idVol) {
        if(idVol == null || idVol.equals("")) return;
        this.idVol = idVol;
    }

    public String getIdVol() {
        return idVol;
    }
    
    public Integer getId_limit_reservation() {
        return id_limit_reservation;
    }
    public void setId_limit_reservation(Integer id_limit_reservation) {
        this.id_limit_reservation = id_limit_reservation;
    }
    public Double getNbHrs() {
        return nbHrs;
    }
    public void setNbHrs(Double nb_hrs) {
        this.nbHrs = nb_hrs;
    }
    public Timestamp getDateApplication() {
        return dateApplication;
    }
    public void setDateApplication(Timestamp date_application) {
        this.dateApplication = date_application;
    }

    public LimitReservation(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }

    public boolean isRespect(Timestamp timestamp,Timestamp date_depart){
        long hourToAdd = (long)nbHrs.doubleValue();

        // Conversion du Timestamp en LocalDateTime
        LocalDateTime dateTime = timestamp.toLocalDateTime();

        // Ajout des heures
        LocalDateTime newDateTime = dateTime.plusHours(hourToAdd);
        System.out.println(newDateTime.toString());
        Timestamp newTimestamp = Timestamp.valueOf(newDateTime);

        return date_depart.after(newTimestamp) || date_depart.equals(newTimestamp); 
    }

    public boolean isValid() throws Exception{
        if(idVol == null || idVol.equals("")) return true;
        long hourToAdd = (long)nbHrs.doubleValue();

        // Conversion du Timestamp en LocalDateTime
        LocalDateTime dateTime = dateApplication.toLocalDateTime();

        // Ajout des heures
        LocalDateTime newDateTime = dateTime.plusHours(hourToAdd);
        Timestamp newTimestamp = Timestamp.valueOf(newDateTime);

        Vol v = new Vol();
        v.setIdVol(idVol);
        Object[] o = v.find(null,v,null,null,"");
        if(o.length == 0) throw new Exception("L'avion "+idVol+" n'existe pas");

        v = (Vol)o[0];

        return v.getDateDepart().after(newTimestamp);
    }
}
