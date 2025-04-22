package itu.project.aeroport.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import itu.project.aeroport.model.reservation.Client;
import itu.project.aeroport.model.users.Users;
import itu.project.aeroport.repository.ClientRepository;

@Service
public class ClientService {
    @Autowired
    ClientRepository repository;

    public Client getClient(Users user){
        Client res = null;
        List<Client> clients = repository.findByUser(user);
        if(clients.size() > 0) res = clients.get(0);
        return res;
    }
}
