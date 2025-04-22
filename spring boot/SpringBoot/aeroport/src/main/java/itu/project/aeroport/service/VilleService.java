package itu.project.aeroport.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import itu.project.aeroport.model.vol.Ville;
import itu.project.aeroport.repository.VilleRepository;

@Service
public class VilleService {
    @Autowired
    private VilleRepository repository;

    public Ville[] getAll(){
        return repository.findAll().toArray(new Ville[0]);
    }
}
