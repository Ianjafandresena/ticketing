package aeroport.reservation;

import utility.Entity;
import utility.annotation.Table;

@Table(name="client")
public class Client extends Entity<Client>{
    String id_client;
    String nom;
    String prenom;
    Integer age;
    String id_users;
    
    
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
    public Integer getAge() {
        return age;
    }
    public void setAge(Integer age) {
        this.age = age;
    }
    public String getId_users() {
        return id_users;
    }
    public void setId_users(String id_users) {
        this.id_users = id_users;
    }

    public Client(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }
}
