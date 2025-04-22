package aeroport.reservation;

import utility.Entity;
import utility.annotation.Table;
import utility.annotation.Column;
import utility.annotation.Ignore;

@Table(name="categorie_passager")
public class CategoriePassager extends Entity<CategoriePassager>{
    @Column(name="id_categorie_passager")
    String idCategoriePassager;

    String designation;

    public String getIdCategoriePassager() {
        return idCategoriePassager;
    }

    public void setIdCategoriePassager(String idCategoriePassager) {
        this.idCategoriePassager = idCategoriePassager;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public CategoriePassager(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
