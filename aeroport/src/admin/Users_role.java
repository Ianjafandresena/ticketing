package admin;

import utility.Entity;
import utility.annotation.Table;

@Table(name="users_role")
public class Users_role extends Entity<Users_role>{
    String id_users;
    Integer id_role;
    
    public String getId_users() {
        return id_users;
    }
    public void setId_user(String id_user) {
        this.id_users = id_user;
    }
    public Integer getId_role() {
        return id_role;
    }
    public void setId_role(Integer id_role) {
        this.id_role = id_role;
    }

    public Users_role(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
