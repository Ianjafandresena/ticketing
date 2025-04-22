package itu.project.aeroport.service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import itu.project.aeroport.model.vol.Vol;
import itu.project.aeroport.repository.VolRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

@Service
public class VolService {

    @Autowired
    private VolRepository repository;

    @PersistenceContext
    private EntityManager entityManager;


    public Vol[] search(Vol vol,Duration dureeMin,Duration dureeMax){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Vol> query = cb.createQuery(Vol.class);
        Root<Vol> vols = query.from(Vol.class);

        List<Predicate> predicates = new ArrayList<>();

        predicates.add(cb.conjunction());

        if(vol.getDepart() != null){
            predicates.add(cb.equal(vols.get("depart"), vol.getDepart()));
        }

        if(vol.getDestination() != null){
            predicates.add(cb.equal(vols.get("destination"), vol.getDestination()));
        }

        if(dureeMin != null){
            predicates.add(cb.greaterThanOrEqualTo(vols.get("duree_vol"), dureeMin));
        }

        if(dureeMax != null){
            predicates.add(cb.lessThanOrEqualTo(vols.get("duree_vol"), dureeMax));
        }

        query.select(vols).where(predicates.toArray(new Predicate[0]));

        return entityManager.createQuery(query).getResultList().toArray(new Vol[0]);


        // Example<Vol> volsList = Example.of(vol);
        // List<Vol> list = repository.findAll(volsList);

        // return list.toArray(new Vol[0]);
    }

    public Vol[] listAll(){
        return repository.findAll().toArray(new Vol[0]);
    }

    public Vol get(String idVol){
        return repository.getReferenceById(idVol);
    }
}
