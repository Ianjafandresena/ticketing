package controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import controller.Context;
import aeroport.Ville;
import aeroport.avion.Avion;
import aeroport.avion.Type_siege;
import aeroport.reservation.Reservation;
import aeroport.vol.Vol;
import aeroport.vol.Vol_avion;
import aeroport.vol.Vol_tarif;
import controller.util.Duree;
import mg.itu.annotation.Authentification;
import mg.itu.annotation.ControlleurAnnotation;
import mg.itu.annotation.Param;
import mg.itu.annotation.Post;
import mg.itu.annotation.Url;
import mg.itu.utils.FileMap;
import mg.itu.utils.ModelView;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import mg.itu.utils.MySession;

import jakarta.servlet.http.HttpServletRequest;

@ControlleurAnnotation(url="/vol")
public class VolController {

    // Méthode par défaut sans paramètres pour /listVol
    @Url(url="/listVol")
    public ModelView listVolDefaut() throws Exception{
        return performListVol("", "", "", 0, 0, 0, 0);
    }

    // Méthode avec paramètres pour les recherches filtrées
    @Url(url="/searchVol")
    public ModelView searchVol(
        @Param(name="vol_idVol") String idVol,
        @Param(name="vol_depart") String depart,
        @Param(name="vol_destination") String destination,
        @Param(name="dureeMax_heure") Integer dureeMaxHeure,
        @Param(name="dureeMax_minute") Integer dureeMaxMinute,
        @Param(name="dureeMin_heure") Integer dureeMinHeure,
        @Param(name="dureeMin_minute") Integer dureeMinMinute
    ) throws Exception{
        return performListVol(idVol, depart, destination, dureeMaxHeure, dureeMaxMinute, dureeMinHeure, dureeMinMinute);
    }

    // Méthode commune qui fait le travail réel
    private ModelView performListVol(String idVol, String depart, String destination, 
                                   Integer dureeMaxHeure, Integer dureeMaxMinute, 
                                   Integer dureeMinHeure, Integer dureeMinMinute) throws Exception{

        try {
            System.out.println("=== DEBUT listVol ===");
            System.out.println("Paramètres reçus:");
            System.out.println("- ID Vol: " + idVol);
            System.out.println("- Départ: " + depart);
            System.out.println("- Destination: " + destination);
            System.out.println("- Durée max: " + dureeMaxHeure + "h" + dureeMaxMinute + "m");
            System.out.println("- Durée min: " + dureeMinHeure + "h" + dureeMinMinute + "m");
            
            // Créer les objets avec valeurs par défaut pour éviter les null
            Vol vol = new Vol();
            if (idVol != null && !idVol.trim().isEmpty()) {
                vol.setIdVol(idVol);
            }
            if (depart != null && !depart.trim().isEmpty()) {
                vol.setDepart(depart);
            }
            if (destination != null && !destination.trim().isEmpty()) {
                vol.setDestination(destination);
            }
            
            Duree dureeMax = new Duree();
            if (dureeMaxHeure != null) dureeMax.setHeure(dureeMaxHeure);
            else dureeMax.setHeure(0);
            if (dureeMaxMinute != null) dureeMax.setMinute(dureeMaxMinute);
            else dureeMax.setMinute(0);
            
            Duree dureeMin = new Duree();
            if (dureeMinHeure != null) dureeMin.setHeure(dureeMinHeure);
            else dureeMin.setHeure(0);
            if (dureeMinMinute != null) dureeMin.setMinute(dureeMinMinute);
            else dureeMin.setMinute(0);
            
            ArrayList<String> ecartColumn = new ArrayList<>();
            ArrayList<Map<String,Object>> ecartValue = new ArrayList<>();

            Map<String,Object> map = new HashMap<>();
            if(dureeMin.getHeure() > 0 || dureeMin.getMinute() > 0){
                map.put("min", dureeMin.toIntervalPG());
            }
            if(dureeMax.getHeure() > 0 || dureeMax.getMinute() > 0){
                map.put("max", dureeMax.toIntervalPG());
            }

            if(map.containsKey("min") || map.containsKey("max")){
                ecartColumn.add("duree_vol");
                ecartValue.add(map);
            }
            
            Object[] obj = vol.find(null,vol,ecartColumn,ecartValue,"");

            Vol[] vols = new Vol[obj.length];
            Ville[] villes = Context.getVilles();

            for(int i = 0; i<obj.length; i++){
                vols[i] = (Vol)obj[i];
                vols[i].setDispo();
            }
            
            ModelView mv = new ModelView();
            mv.addObject("list_vols", vols);
            mv.addObject("list_villes", villes);
            mv.setViewUrl("vol_list.jsp");
            return mv;
            
        } catch (Exception e) {
            System.err.println("Erreur dans listVol: " + e.getMessage());
            e.printStackTrace();
            
            ModelView mv = new ModelView();
            mv.addObject("errorMessage", "Erreur lors de la recherche: " + e.getMessage());
            
            // Charger les villes pour le formulaire de filtre
            try {
                Ville[] villes = Context.getVilles();
                mv.addObject("list_villes", villes);
            } catch (Exception villeException) {
                System.err.println("Erreur lors du chargement des villes: " + villeException.getMessage());
            }
            
            mv.setViewUrl("vol_list.jsp");
            return mv;
        }
    }

    // Méthode pour la compatibilité avec les appels existants
    public ModelView listVol(Vol vol, Duree dureeMax, Duree dureeMin) throws Exception {
        return performListVol(
            vol != null ? vol.getIdVol() : "",           
            vol != null ? vol.getDepart() : "",          
            vol != null ? vol.getDestination() : "",     
            dureeMax != null ? dureeMax.getHeure() : 0,      
            dureeMax != null ? dureeMax.getMinute() : 0,     
            dureeMin != null ? dureeMin.getHeure() : 0,      
            dureeMin != null ? dureeMin.getMinute() : 0      
        );
    }

    @Post
    @Url(url="/register")
    @Authentification(role = {"admin"})
    public ModelView saveVol(
        @Param(name="vol.depart") String depart,
        @Param(name="vol.destination") String destination, 
        @Param(name="vol.dateDepart") String dateDepart,
        @Param(name="duree.heure") Integer heure,
        @Param(name="duree.minute") Integer minute,
        @Param(name="business.tarif") Double tarifBusiness,
        @Param(name="eco.tarif") Double tarifEco,
        @Param(name="idAvion") String idAvion
    ) throws Exception {
        
        try {
            Vol vol = new Vol();
            vol.setDepart(depart);
            vol.setDestination(destination);
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Timestamp timestamp = new Timestamp(sdf.parse(dateDepart).getTime());
            vol.setDateDepart(timestamp);
            
            Duree duree = new Duree();
            duree.setHeure(heure);
            duree.setMinute(minute);
            vol.setDuree_vol(duree.toIntervalPG());
            
            String id_vol = (String)vol.insert();
            
            Vol_tarif tarifBus = new Vol_tarif();
            tarifBus.setId_vol(id_vol);
            tarifBus.setIdTypeSiege("TYP000001");
            tarifBus.setTarif(tarifBusiness);
            tarifBus.insert();
            
            Vol_tarif tarifEconomique = new Vol_tarif();
            tarifEconomique.setId_vol(id_vol);
            tarifEconomique.setIdTypeSiege("TYP000002");
            tarifEconomique.setTarif(tarifEco);
            tarifEconomique.insert();
            
            Vol_avion volAvion = new Vol_avion();
            volAvion.setId_vol(id_vol);
            volAvion.setId_avion(idAvion);
            volAvion.insert();
            
            // Redirection vers la liste par défaut
            return listVolDefaut();
            
        } catch(Exception e) {
            e.printStackTrace();
            ModelView mv = new ModelView();
            mv.addObject("errorMessage", "Erreur lors de la création du vol: " + e.getMessage());
            
            Avion[] avionList = Context.getAvions();
            Ville[] villes = Context.getVilles();
            mv.addObject("list_avion", avionList);
            mv.addObject("list_villes", villes);
            mv.setViewUrl("form_avion.jsp");
            return mv;
        }
    }

    @Post
    @Url(url="/attributeAvion")
    @Authentification(role= {"admin"})
    public ModelView setAvion(@Param(name="vol_avion")Vol_avion avions) throws Exception{
        avions.insert();
        return listVolDefaut();
    }

    @Url(url="/formInsertV")
    @Authentification(role={"admin"})
    public ModelView redirectFormInsert() throws Exception{
        ModelView mv = new ModelView();
        Avion[] avionList = Context.getAvions();
        Ville[] villes = Context.getVilles();

        mv.addObject("list_avion", avionList);
        mv.addObject("list_villes", villes);
        mv.setViewUrl("form_avion.jsp");
        return mv;
    }

    @Url(url="/formReserv")
    public ModelView redirectFormReserv(@Param(name="idVol")String id_vol) throws Exception{
        ModelView mv = new ModelView();
        Type_siege[] sieges = Context.getSieges();
        mv.addObject("list_siege", sieges);
        mv.addObject("id_vol",id_vol);
        mv.setViewUrl("form_reserv.jsp");
        return mv;
    }

    @Url(url="/listAllReservation")
    @Authentification(role={"admin"})
    public ModelView listAll(@Param(name="errorMessage")String errorMessage) throws Exception{
        Reservation[] reservations = Reservation.listAll();
        Vol[] vols = new Vol().getAll();
        Avion[] avions = Context.getAvions();
        Type_siege[] sieges = Context.getSieges();
        Ville[] villes = Context.getVilles();

        ModelView mv = new ModelView();
        mv.addObject("list_vols", vols);
        mv.addObject("list_siege", sieges);
        mv.addObject("list_avions",avions);
        mv.addObject("list_villes",villes);
        mv.addObject("list_reservations", reservations);
        mv.addObject("errorMessage", errorMessage);
        mv.setViewUrl("reserv_list.jsp");
        return mv;
    }

    @Url(url="/listReservation")
    public ModelView list(MySession session,@Param(name="errorMessage")String errorMessage) throws Exception{
        String id_client = (String)session.get("id_client");
        Reservation r = new Reservation();
        r.setIdClient(id_client);
        Object[] obj = r.find(null,r,null,null,"");
        Reservation[] reservations = new Reservation[obj.length];
        for(int i = 0; i<obj.length; i++){
            reservations[i] = (Reservation)obj[i];
            reservations[i].setClasse();
            reservations[i].setCli();
        }
        Vol[] vols = new Vol().getAll();
        Avion[] avions = Context.getAvions();
        Type_siege[] sieges = Context.getSieges();
        Ville[] villes = Context.getVilles();

        ModelView mv = new ModelView();
        mv.addObject("list_vols", vols);
        mv.addObject("list_siege", sieges);
        mv.addObject("list_avions",avions);
        mv.addObject("list_villes",villes);
        mv.addObject("list_reservations", reservations);
        mv.addObject("errorMessage", errorMessage);
        mv.setViewUrl("reserv_list.jsp");

        return mv;
    }

    @Post
@Url(url="/makeReservation")
public ModelView makeReservation(
    @Param(name="idVol") String idVol,
    @Param(name="idClient") String idClient,
    @Param(name="idTypeSiege") String idTypeSiege,
    @Param(name="nbEnfant") Integer nbEnfant,
    @Param(name="nbAdulte") Integer nbAdulte,
    @Param(name="dateReservation") String dateReservation
) throws Exception {
    
    ModelView mv = new ModelView();
    
    try {
        System.out.println("=== DEBUT makeReservation ===");
        
        Reservation reservation = new Reservation();
        
        // ... tout le code existant pour créer la réservation ...
        
        if (idVol == null || idVol.trim().isEmpty()) {
            throw new Exception("L'ID du vol est obligatoire");
        }
        reservation.setIdVol(idVol);
        
        if (idTypeSiege == null || idTypeSiege.trim().isEmpty()) {
            throw new Exception("Le type de siège est obligatoire");
        }
        reservation.setIdTypeSiege(idTypeSiege);
        
        if (nbAdulte == null || nbAdulte <= 0) {
            throw new Exception("Au moins un adulte est requis");
        }
        reservation.setNbAdulte(nbAdulte);
        
        if (nbEnfant == null) {
            reservation.setNbEnfant(0);
        } else {
            reservation.setNbEnfant(nbEnfant);
        }
        
        if (idClient != null && !idClient.trim().isEmpty()) {
            reservation.setIdClient(idClient);
        }
        
        if (dateReservation != null && !dateReservation.trim().isEmpty()) {
            try {
                java.time.LocalDateTime localDateTime = java.time.LocalDateTime.parse(dateReservation);
                java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(localDateTime);
                reservation.setDateReservation(timestamp);
            } catch (Exception dateException) {
                throw new Exception("Format de date invalide: " + dateReservation);
            }
        } else {
            reservation.setDateReservation(new java.sql.Timestamp(System.currentTimeMillis()));
        }
        
        reservation.setStatus("pending");
        
        if (!reservation.isValid()) {
            mv.setViewUrl("form_reserv.jsp");
            Type_siege[] sieges = Context.getSieges();
            mv.addObject("list_siege", sieges);
            mv.addObject("id_vol", idVol);
            mv.addObject("errorMessage", "La réservation n'a pu être validée.");
            return mv;
        }
        
        Double tarif = reservation.getTarif();
        if (tarif == null || tarif <= 0) {
            throw new Exception("Impossible de calculer le tarif");
        }
        reservation.setPrix(tarif);
        
        // INSERTION DE LA RÉSERVATION
        String reservationId = (String) reservation.insert();
        System.out.println("Réservation créée avec l'ID : " + reservationId);
        
        // *** NOUVEAU CODE : Mettre à jour la promotion après insertion ***
        try {
            reservation.updatePromotionAfterReservation();
        } catch (Exception promoException) {
            System.err.println("Erreur lors de la mise à jour de la promotion: " + promoException.getMessage());
            // Ne pas faire échouer la réservation pour autant
        }
        
        return listVolDefaut();
        
    } catch (Exception e) {
        System.err.println("=== ERREUR dans makeReservation ===");
        e.printStackTrace();
        
        mv.setViewUrl("form_reserv.jsp");
        try {
            Type_siege[] sieges = Context.getSieges();
            mv.addObject("list_siege", sieges);
        } catch (Exception contextException) {
            System.err.println("Erreur lors du chargement des sièges : " + contextException.getMessage());
        }
        
        if (idVol != null) {
            mv.addObject("id_vol", idVol);
        }
        
        mv.addObject("errorMessage", "Erreur lors de la réservation : " + e.getMessage());
        return mv;
    }
}

    // Nouvelle méthode pour marquer une réservation comme payée
    @Post
    @Url(url="/markAsPaid")
    public ModelView markAsPaid(
        MySession session,
        @Param(name="idReservation") String idReservation
    ) throws Exception {
        
        String role = (String)session.get("role");
        String errorMessage = "";
        
        try {
            System.out.println("=== DEBUT markAsPaid ===");
            System.out.println("ID Réservation: " + idReservation);
            
            if (idReservation == null || idReservation.trim().isEmpty()) {
                throw new Exception("ID de réservation manquant");
            }
            
            Reservation r = new Reservation();
            r.setIdReservation(idReservation);
            Object[] obj = r.find(null, r, null, null, "");
            
            if (obj.length == 0) {
                throw new Exception("La réservation " + idReservation + " n'existe pas");
            }
            
            r = (Reservation)obj[0];
            
            // Vérifier que la réservation n'est pas déjà annulée
            if ("cancelled".equals(r.getStatus())) {
                throw new Exception("Impossible de payer une réservation annulée");
            }
            
            // Marquer comme payée
            r.markAsPaid();
            System.out.println("Réservation " + idReservation + " marquée comme payée");
            
        } catch (Exception e) {
            System.err.println("Erreur lors du paiement: " + e.getMessage());
            e.printStackTrace();
            errorMessage = "Erreur lors du paiement: " + e.getMessage();
        }
        
        // Rediriger selon le rôle
        if (role != null && role.equals("admin")) {
            return listAll(errorMessage);
        }
        return list(session, errorMessage);
    }

    @Url(url="/formAnnul")
    public ModelView redirectFormAnnul(@Param(name="idReservation")String id_reservation) throws Exception{
        ModelView mv = new ModelView();
        mv.setViewUrl("annul_reserv.jsp");
        mv.addObject("id_reservation", id_reservation);
        return mv;
    }

    @Url(url="/annulerReservation")
    @Post
    public ModelView annuler(MySession session,@Param(name="idReservation")String id_reservation,@Param(name="dateAnnulation")String date_annulation) throws Exception{
        String role = (String)session.get("role");
        Reservation r = new Reservation();
        r.setIdReservation(id_reservation);
        Object[] o = r.find(null,r,null,null,"");
        if(o.length == 0) throw new Exception("La reservation "+id_reservation+" n'existe pas");
        r = (Reservation)o[0];
        String errorMessage = "";

        try {
            String dateFormatted = convertDateTimeLocal(date_annulation);
            
            if(!r.canAnnulate(dateFormatted)){
                errorMessage = "Cette reservation ne peut pas être annulée";
            }
            else{
                // Marquer comme annulée au lieu de supprimer
                r.markAsCancelled();
                System.out.println("Réservation " + id_reservation + " marquée comme annulée");
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de l'annulation: " + e.getMessage());
            e.printStackTrace();
            errorMessage = "Erreur lors de l'annulation: " + e.getMessage();
        }
        
        if(role != null && role.equals("admin")) return listAll(errorMessage);
        return list(session,errorMessage);
    }

    private String convertDateTimeLocal(String dateTimeLocal) {
        if (dateTimeLocal == null || dateTimeLocal.trim().isEmpty()) {
            return "";
        }
        
        try {
            java.time.LocalDateTime localDateTime = java.time.LocalDateTime.parse(dateTimeLocal);
            java.time.format.DateTimeFormatter formatter = 
                java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            return localDateTime.format(formatter);
        } catch (Exception e) {
            System.err.println("Erreur conversion date: " + e.getMessage());
            return dateTimeLocal;
        }
    }
}