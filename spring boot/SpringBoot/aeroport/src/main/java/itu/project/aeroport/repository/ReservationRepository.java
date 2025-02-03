package itu.project.aeroport.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import itu.project.aeroport.model.reservation.Client;
import itu.project.aeroport.model.reservation.Reservation;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation,String>{
    List<Reservation> findByClient(Client client);
}
