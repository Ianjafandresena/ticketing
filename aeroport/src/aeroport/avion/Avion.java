package aeroport.avion;

import java.sql.Date;

import utility.Entity;
import utility.annotation.Table;

@Table(name="avion")
public class Avion extends Entity<Avion>{
    String id_avion;
    String model;
    Date date_fabrication;

    
    public String getId_avion() {
        return id_avion;
    }
    public void setId_avion(String id_avion) {
        this.id_avion = id_avion;
    }
    public String getModel() {
        return model;
    }
    public void setModel(String model) {
        this.model = model;
    }
    public Date getDate_fabrication() {
        return date_fabrication;
    }
    public void setDate_fabrication(Date date_fabrication) {
        this.date_fabrication = date_fabrication;
    }

    public Avion(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
