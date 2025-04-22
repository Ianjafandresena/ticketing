package admin;

import utility.Entity;
import utility.annotation.Table;

@Table(name="role")
public class Role extends Entity<Role>{
    Integer id_role;
    String designation;

    public Integer getId_role() {
        return id_role;
    }
    public void setId_role(Integer id_role) {
        this.id_role = id_role;
    }
    public String getDesignation() {
        return designation;
    }
    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Role(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
