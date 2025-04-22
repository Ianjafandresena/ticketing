package admin;

import java.util.ArrayList;
// import org.mindrot.jbcrypt.BCrypt;

import utility.Entity;
import utility.annotation.Encrypt;
import utility.annotation.Table;

@Table(name="users")
public class Users extends Entity<Users>{
    String id_users;
    String login;
    @Encrypt
    String password;
    
    public String getId_users() {
        return id_users;
    }
    public void setId_users(String id_users) {
        this.id_users = id_users;
    }
    public String getLogin() {
        return login;
    }
    public void setLogin(String login) {
        this.login = login;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String passwords) {
        this.password = passwords;
    }

    public String getRole() throws Exception{
        Users_role ur = new Users_role();
        ur.setId_user(id_users);
        Role r = new Role();
        ur.join(r, "id_role", "id_role","=","");
        ArrayList<String> columnTarget = new ArrayList<>();
        columnTarget.add("role.id_role");
        columnTarget.add("role.designation");
        r = (Role)ur.find(columnTarget,r,null,null,"")[0];
        return r.getDesignation();
    }

    public Users isValid() throws Exception{
        Object[] obj = this.find(null, this, null, null, "");
        // if(obj.length == 0) throw new Exception("user inexistant");
        return (Users)obj[0];
    }

    public Users(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
