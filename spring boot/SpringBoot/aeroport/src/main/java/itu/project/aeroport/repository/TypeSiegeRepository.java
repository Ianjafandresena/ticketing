package itu.project.aeroport.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import itu.project.aeroport.model.avion.TypeSiege;

@Repository
public interface TypeSiegeRepository extends JpaRepository<TypeSiege,String>{
}
