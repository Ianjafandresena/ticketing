package itu.project.aeroport.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import itu.project.aeroport.model.vol.Ville;

@Repository
public interface VilleRepository extends JpaRepository<Ville,String>{
}
