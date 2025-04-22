package controller;

import aeroport.avion.Type_siege;
import aeroport.reservation.LimitAnnulation;
import aeroport.reservation.LimitReservation;
import aeroport.vol.Promotion;
import aeroport.vol.Vol;
import mg.itu.annotation.Authentification;
import mg.itu.annotation.ControlleurAnnotation;
import mg.itu.annotation.Param;
import mg.itu.annotation.Post;
import mg.itu.annotation.Url;
import mg.itu.utils.ModelView;

@ControlleurAnnotation(url="/rules")
@Authentification(role={"admin"})
public class Rules {
    @Url(url="/formAnnulR")
    public ModelView redirectAnnulation(@Param(name="errorMessage")String errorMessage) throws Exception{
        ModelView mv = new ModelView();
        Vol[] vols = new Vol().getAll();
        mv.addObject("list_vol", vols);
        mv.addObject("errorMessage", errorMessage);
        mv.setViewUrl("limit_annul.jsp");
        return mv;
    }

    @Url(url="/formReservR")
    public ModelView redirectReserv(@Param(name="errorMessage")String errorMessage) throws Exception{
        ModelView mv = new ModelView();
        Vol[] vols = new Vol().getAll();
        mv.addObject("list_vol", vols);
        mv.addObject("errorMessage", errorMessage);
        mv.setViewUrl("limit_reserv.jsp");
        return mv;
    }

    @Url(url="/formPromo")
    public ModelView redirectPromo(@Param(name="errorMessage")String errorMessage) throws Exception{
        ModelView mv = new ModelView();
        Type_siege ts = new Type_siege();
        Type_siege[] sieges = ts.getAll();
        Vol[] vols = new Vol().getAll();
        mv.addObject("list_siege", sieges);
        mv.addObject("errorMessage", errorMessage);
        mv.addObject("list_vol", vols);
        mv.setViewUrl("form_promotion.jsp");
        return mv;
    }

    @Post
    @Url(url="/setReserv")
    public ModelView reserv(
        @Param(name="dateApplication") String dateApplication,
        @Param(name="nbHrs") Double nbHrs,
        @Param(name="idVol") String idVol
    ) throws Exception{
        
        try {
            System.out.println("=== DEBUT setReserv ===");
            System.out.println("Paramètres reçus:");
            System.out.println("- Date application: " + dateApplication);
            System.out.println("- Nb heures: " + nbHrs);
            System.out.println("- Vol: " + idVol);
            
            LimitReservation reserv = new LimitReservation();
            
            if (nbHrs == null || nbHrs < 0) {
                throw new Exception("Le nombre d'heures doit être positif");
            }
            reserv.setNbHrs(nbHrs);
            
            if (dateApplication != null && !dateApplication.trim().isEmpty()) {
                try {
                    java.time.LocalDateTime localDateTime = java.time.LocalDateTime.parse(dateApplication);
                    java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(localDateTime);
                    reserv.setDateApplication(timestamp);
                } catch (Exception dateException) {
                    throw new Exception("Format de date invalide: " + dateApplication);
                }
            } else {
                throw new Exception("La date d'application est obligatoire");
            }
            
            if (idVol != null && !idVol.trim().isEmpty()) {
                reserv.setIdVol(idVol);
            }
            
            if (!reserv.isValid()) {
                return redirectReserv("La date d'application doit être cohérente");
            }
            
            reserv.insert();
            System.out.println("Limite de réservation créée avec succès");
            
            return redirectReserv("");
            
        } catch (Exception e) {
            System.err.println("Erreur dans setReserv: " + e.getMessage());
            e.printStackTrace();
            return redirectReserv("Erreur lors de la création de la limite: " + e.getMessage());
        }
    }

    @Post
    @Url(url="/setAnnul")
    public ModelView annul(
        @Param(name="dateApplication") String dateApplication,
        @Param(name="nbHrs") Double nbHrs,
        @Param(name="idVol") String idVol
    ) throws Exception{
        
        try {
            System.out.println("=== DEBUT setAnnul ===");
            System.out.println("Paramètres reçus:");
            System.out.println("- Date application: " + dateApplication);
            System.out.println("- Nb heures: " + nbHrs);
            System.out.println("- Vol: " + idVol);
            
            LimitAnnulation annulation = new LimitAnnulation();
            
            if (nbHrs == null || nbHrs < 0) {
                throw new Exception("Le nombre d'heures doit être positif");
            }
            annulation.setNbHrs(nbHrs);
            
            if (dateApplication != null && !dateApplication.trim().isEmpty()) {
                try {
                    java.time.LocalDateTime localDateTime = java.time.LocalDateTime.parse(dateApplication);
                    java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(localDateTime);
                    annulation.setDateApplication(timestamp);
                } catch (Exception dateException) {
                    throw new Exception("Format de date invalide: " + dateApplication);
                }
            } else {
                throw new Exception("La date d'application est obligatoire");
            }
            
            if (idVol != null && !idVol.trim().isEmpty()) {
                annulation.setIdVol(idVol);
            }
            
            if (!annulation.isValid()) {
                return redirectAnnulation("La date d'application doit être cohérente");
            }
            
            annulation.insert();
            System.out.println("Limite d'annulation créée avec succès");
            
            return redirectAnnulation("");
            
        } catch (Exception e) {
            System.err.println("Erreur dans setAnnul: " + e.getMessage());
            e.printStackTrace();
            return redirectAnnulation("Erreur lors de la création de la limite: " + e.getMessage());
        }
    }

    @Post
    @Url(url="/makePromo")
    public ModelView promotion(
        @Param(name="dateFin") String dateFin,
        @Param(name="prixPromotion") Double prixPromotion,
        @Param(name="nbSiege") Integer nbSiege,
        @Param(name="idVol") String idVol,
        @Param(name="idTypeSiege") String idTypeSiege
    ) throws Exception{
        
        try {
            System.out.println("=== DEBUT makePromo ===");
            System.out.println("Paramètres reçus:");
            System.out.println("- Date fin: " + dateFin);
            System.out.println("- Prix promotion: " + prixPromotion);
            System.out.println("- Nb sièges: " + nbSiege);
            System.out.println("- Vol: " + idVol);
            System.out.println("- Type siège: " + idTypeSiege);
            
            Promotion promotion = new Promotion();
            
            if (idVol == null || idVol.trim().isEmpty()) {
                throw new Exception("Le vol est obligatoire");
            }
            promotion.setIdVol(idVol);
            
            if (idTypeSiege == null || idTypeSiege.trim().isEmpty()) {
                throw new Exception("Le type de siège est obligatoire");
            }
            promotion.setIdTypeSiege(idTypeSiege);
            
            if (prixPromotion == null || prixPromotion <= 0) {
                throw new Exception("Le prix de promotion doit être supérieur à 0");
            }
            promotion.setPrixPromotion(prixPromotion);
            
            if (nbSiege == null || nbSiege <= 0) {
                throw new Exception("Le nombre de sièges doit être supérieur à 0");
            }
            promotion.setNbSiege(nbSiege);
            
            if (dateFin != null && !dateFin.trim().isEmpty()) {
                try {
                    java.time.LocalDateTime localDateTime = java.time.LocalDateTime.parse(dateFin);
                    java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(localDateTime);
                    promotion.setDateFin(timestamp);
                } catch (Exception dateException) {
                    throw new Exception("Format de date de fin invalide: " + dateFin);
                }
            } else {
                throw new Exception("La date de fin est obligatoire");
            }
            
            if (!promotion.isValid()) {
                return redirectPromo("Cette promotion ne peut être appliquée pour cette date");
            }
            
            promotion.insert();
            System.out.println("Promotion créée avec succès");
            
            return redirectPromo("");
            
        } catch (Exception e) {
            System.err.println("Erreur dans makePromo: " + e.getMessage());
            e.printStackTrace();
            return redirectPromo("Erreur lors de la création de la promotion: " + e.getMessage());
        }
    }

    @Url(url="/listPromotions")
public ModelView listPromotions() throws Exception {
    Promotion promo = new Promotion();
    Promotion[] promotions = promo.getAll();
    
    ModelView mv = new ModelView();
    mv.addObject("list_promotions", promotions);
    mv.setViewUrl("promotion_list.jsp");
    return mv;
}
}