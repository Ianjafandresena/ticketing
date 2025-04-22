package itu.project.aeroport.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import itu.project.aeroport.model.reservation.Client;
import itu.project.aeroport.model.users.Users;

@Repository
public interface ClientRepository extends JpaRepository<Client,String>{
    List<Client> findByUser(Users user);
}
