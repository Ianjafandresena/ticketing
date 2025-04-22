package itu.project.aeroport.model.users;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="users")
public class Users {
    @Id
    private String id_users;

    private String login;
    private String password;

    
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
    public void setPassword(String password) {
        this.password = password;
    }
}
