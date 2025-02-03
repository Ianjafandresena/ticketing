package itu.project.aeroport.model.users;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="role")
public class Role {
    @Id
    int id_role;

    String designation;

    public int getId_role() {
        return id_role;
    }

    public void setId_role(int id_role) {
        this.id_role = id_role;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public static boolean verif(Role[] roles,String target){
        for(Role r: roles){
            if(r.getDesignation().equals(target)){
                return true;
            }
        }
        return false;
    }
}
