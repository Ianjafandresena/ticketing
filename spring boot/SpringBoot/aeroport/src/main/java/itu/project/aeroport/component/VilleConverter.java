package itu.project.aeroport.component;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;


import itu.project.aeroport.model.vol.Ville;
import itu.project.aeroport.repository.VilleRepository;

@Component
public class VilleConverter implements Converter<String,Ville>{
    @Autowired
    private VilleRepository villeRepository;

    @Override
    public Ville convert(String id) {
        return villeRepository.findById(id).orElse(null);
    }
}
