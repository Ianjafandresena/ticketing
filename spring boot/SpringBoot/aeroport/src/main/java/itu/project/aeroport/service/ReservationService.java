package itu.project.aeroport.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import itu.project.aeroport.model.reservation.Client;
import itu.project.aeroport.model.reservation.Reservation;
import itu.project.aeroport.repository.ReservationRepository;

@Service
public class ReservationService {
    @Autowired
    ReservationRepository repository;

    public Reservation[] getAll(){
        List<Reservation> list = repository.findAll();
        return list.toArray(new Reservation[0]);
    }
    
    public Reservation[] getByClient(Client client){
        List<Reservation> list = repository.findByClient(client);
        return list.toArray(new Reservation[0]);
    }

    
}
