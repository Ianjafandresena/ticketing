package itu.project.aeroport.model.id;

import java.util.Objects;

import jakarta.persistence.Embeddable;

@Embeddable
public class IdRoleUsers {
    private String id_users;
    private int id_role;

    public IdRoleUsers(){}
    public IdRoleUsers(String id,int ro){
        this.id_users = id;
        this.id_role = ro;
    }

    public String getId_users() {
        return id_users;
    }
    public void setId_users(String id_users) {
        this.id_users = id_users;
    }
    public int getId_role() {
        return id_role;
    }
    public void setId_role(int id_role) {
        this.id_role = id_role;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        IdRoleUsers that = (IdRoleUsers) o;
        return Objects.equals(id_users, that.id_users) && Objects.equals(id_role, that.id_role);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id_users, id_role);
    }
}
