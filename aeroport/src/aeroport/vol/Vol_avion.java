package aeroport.vol;

import mg.itu.annotation.type.Text;
import utility.Entity;
import utility.annotation.Table;

@Table(name="vol_avion")
public class Vol_avion extends Entity<Vol_avion>{
    String id_vol_avion;
    @Text
    String id_vol;
    @Text
    String id_avion;
    
    public String getId_vol_avion() {
        return id_vol_avion;
    }
    public void setId_vol_avion(String id_vol_avion) {
        this.id_vol_avion = id_vol_avion;
    }
    public String getId_vol() {
        return id_vol;
    }
    public void setId_vol(String id_vol) {
        this.id_vol = id_vol;
    }
    public String getId_avion() {
        return id_avion;
    }
    public void setId_avion(String id_avion) {
        this.id_avion = id_avion;
    }

    public Vol_avion(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
