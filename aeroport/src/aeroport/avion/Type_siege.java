package aeroport.avion;

import utility.Entity;
import utility.annotation.Table;

@Table(name="type_siege")
public class Type_siege extends Entity<Type_siege>{
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

    public Type_siege(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
