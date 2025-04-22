package aeroport;

import utility.Entity;
import utility.annotation.Table;

@Table(name="ville")
public class Ville extends Entity<Ville>{
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

    public Ville(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
