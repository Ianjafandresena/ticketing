package itu.project.aeroport.controller;

import itu.project.aeroport.model.vol.Ville;
import itu.project.aeroport.service.VilleService;

public class Context {
    private static final VilleService villeService = new VilleService();
    private static Ville[] villes;
    
    public static void init(){
        villes = villeService.getAll();
    }

    public static Ville[] getVilles(){
        return villes;
    }
}
