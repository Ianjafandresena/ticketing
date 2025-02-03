package itu.project.aeroport.model.users;

import itu.project.aeroport.model.id.IdRoleUsers;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name="users_role")
public class RoleUsers {

    @EmbeddedId
    IdRoleUsers id;

    @ManyToOne
    @JoinColumn(name="id_role",nullable=false,insertable = false,updatable = false)
    Role role;

    @ManyToOne
    @JoinColumn(name="id_users",nullable=false,insertable = false,updatable = false)
    Users user;

    public IdRoleUsers getId() {
        return id;
    }

    public void setId(IdRoleUsers id) {
        this.id = id;
    }


    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

}
