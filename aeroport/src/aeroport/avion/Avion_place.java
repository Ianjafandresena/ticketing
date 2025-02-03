package aeroport.avion;

import utility.Entity;
import utility.annotation.Table;

@Table(name="avion_place")
public class Avion_place extends Entity<Avion_place>{
    Integer id_avion_place;
    String id_type_siege;
    Integer nb;
    
    public Integer getId_avion_place() {
        return id_avion_place;
    }
    public void setId_avion_place(Integer id_avion_place) {
        this.id_avion_place = id_avion_place;
    }
    public String getId_type_siege() {
        return id_type_siege;
    }
    public void setId_type_siege(String id_type_siege) {
        this.id_type_siege = id_type_siege;
    }
    public Integer getNb() {
        return nb;
    }
    public void setNb(Integer nb) {
        this.nb = nb;
    }

    public Avion_place(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
