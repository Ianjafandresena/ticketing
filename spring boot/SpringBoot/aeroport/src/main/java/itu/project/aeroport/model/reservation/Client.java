package itu.project.aeroport.model.reservation;

import itu.project.aeroport.model.users.Users;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name="client")
public class Client {
    @Id
    String id_client;

    String nom;
    String prenom;

    int age;

    @ManyToOne
    @JoinColumn(name="id_users",nullable = true)
    Users user;

    public String getId_client() {
        return id_client;
    }

    public void setId_client(String id_client) {
        this.id_client = id_client;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users users) {
        this.user = users;
    }
}
