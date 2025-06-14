package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import aeroport.reservation.Reservation;
import aeroport.vol.Promotion;
import mg.itu.annotation.Authentification;
import mg.itu.annotation.ControlleurAnnotation;
import mg.itu.annotation.Param;
import mg.itu.annotation.Url;
import mg.itu.utils.ModelView;

@ControlleurAnnotation(url="/cleanup")
@Authentification(role={"admin"})
public class DateCleanupController {

    @Get
    @Url(url="/date")
    public ModelView cleanupByDate(@Param(name="date") String date) throws Exception {
        
        ModelView mv = new ModelView();
        List<String> messages = new ArrayList<>();
        
        try {
            System.out.println("Date reçue: " + date);
            
            if (date == null || date.trim().isEmpty()) {
                throw new Exception("Le paramètre date est obligatoire. Format: dd/MM/yyyy");
            }
            
            Timestamp dateLimite = parseDate(date);
            System.out.println("Date limite convertie: " + dateLimite);
            
            List<Reservation> reservationsACleaner = getReservationsBeforeDate(dateLimite);
            System.out.println("Nombre de réservations trouvées: " + reservationsACleaner.size());
            
            List<Reservation> nonPayees = new ArrayList<>();
            List<Reservation> payees = new ArrayList<>();
            
            for (Reservation res : reservationsACleaner) {
                if ("pending".equals(res.getStatus())) {
                    nonPayees.add(res);
                } else if ("confirmed".equals(res.getStatus())) {
                    payees.add(res);
                }
            }
            
            System.out.println("Réservations non payées à annuler: " + nonPayees.size());
            System.out.println("Réservations payées conservées: " + payees.size());
            
            Map<String, Integer> placesARedistribuer = new HashMap<>(); 
            
            for (Reservation res : nonPayees) {
                try {
                    System.out.println("Traitement réservation: " + res.getIdReservation());
                    
                    int placesPromoUtilisees = calculerPlacesPromotionUtilisees(res, dateLimite);
                    
                    if (placesPromoUtilisees > 0) {
                        String cle = res.getIdVol() + "_" + res.getIdTypeSiege();
                        placesARedistribuer.put(cle, 
                            placesARedistribuer.getOrDefault(cle, 0) + placesPromoUtilisees);
                        System.out.println("Places promo à redistribuer: " + placesPromoUtilisees + " pour " + cle);
                    }
                    
                    res.markAsCancelled();
                    messages.add("Réservation " + res.getIdReservation() + " annulée automatiquement");
                    
                } catch (Exception e) {
                    System.err.println("Erreur lors de l'annulation de " + res.getIdReservation() + ": " + e.getMessage());
                    messages.add("ERREUR: " + res.getIdReservation() + " - " + e.getMessage());
                }
            }
            
            for (Map.Entry<String, Integer> entry : placesARedistribuer.entrySet()) {
                String[] parts = entry.getKey().split("_");
                String idVol = parts[0];
                String idTypeSiege = parts[1];
                int placesARedonner = entry.getValue();
                
                try {
                    redistribuerPlacesPromotion(idVol, idTypeSiege, placesARedonner, dateLimite);
                    messages.add("Redistribué " + placesARedonner + " places pour vol " + idVol + " classe " + idTypeSiege);
                } catch (Exception e) {
                    System.err.println("Erreur redistribution " + entry.getKey() + ": " + e.getMessage());
                    messages.add("ERREUR redistribution: " + e.getMessage());
                }
            }
            
            int promotionsNettoyees = nettoyerPromotionsExpirees(dateLimite);
            if (promotionsNettoyees > 0) {
                messages.add("Nettoyé " + promotionsNettoyees + " promotions expirées");
            }
            
            messages.add("CLEANUP TERMINÉ - " + nonPayees.size() + " réservations annulées");
            
        } catch (Exception e) {
            System.err.println("Erreur dans cleanup: " + e.getMessage());
            e.printStackTrace();
            messages.add("ERREUR GÉNÉRALE: " + e.getMessage());
        }
        
        mv.addObject("messages", messages);
        mv.addObject("dateTraitee", date);
        mv.setViewUrl("cleanup_result.jsp");
        
        System.out.println("=== FIN CLEANUP ===");
        return mv;
    }
    
    private Timestamp parseDate(String dateStr) throws Exception {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            java.util.Date parsedDate = sdf.parse(dateStr);
            return new Timestamp(parsedDate.getTime());
        } catch (Exception e) {
            throw new Exception("Format de date invalide. Utilisez: dd/MM/yyyy (ex: 25/08/2025)");
        }
    }
    
    private List<Reservation> getReservationsBeforeDate(Timestamp dateLimite) throws Exception {
        List<Reservation> resultats = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            Reservation tempRes = new Reservation();
            conn = tempRes.connect();
            
            String sql = "SELECT * FROM reservation WHERE date_reservation < ? ORDER BY date_reservation";
            ps = conn.prepareStatement(sql);
            ps.setTimestamp(1, dateLimite);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation res = new Reservation();
                res.setIdReservation(rs.getString("id_reservation"));
                res.setIdVol(rs.getString("id_vol"));
                res.setIdTypeSiege(rs.getString("id_type_siege"));
                res.setNbEnfant(rs.getInt("nb_enfant"));
                res.setNbAdulte(rs.getInt("nb_adulte"));
                res.setPrix(rs.getDouble("prix"));
                res.setIdClient(rs.getString("id_client"));
                res.setDateReservation(rs.getTimestamp("date_reservation"));
                res.setStatus(rs.getString("status"));
                
                resultats.add(res);
            }
            rs.close();
            
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        
        return resultats;
    }
    
    private int calculerPlacesPromotionUtilisees(Reservation res, Timestamp dateLimite) throws Exception {
        res.setPromotion();
        Promotion promotion = res.getPromotion(); 
        if (promotion == null) return 0;
        
        Timestamp dateRes = res.getDateReservation();
        Timestamp finPromo = promotion.getDateFin();
        
        if (dateRes.before(finPromo)) {
            int totalPersonnes = (res.getNbAdulte() != null ? res.getNbAdulte() : 0) + 
                               (res.getNbEnfant() != null ? res.getNbEnfant() : 0);
            
            System.out.println("Réservation " + res.getIdReservation() + " utilisait " + 
                             totalPersonnes + " places de promotion " + promotion.getId_promotion());
            return totalPersonnes;
        }
        
        return 0;
    }
    
    private void redistribuerPlacesPromotion(String idVol, String idTypeSiege, int placesARedonner, Timestamp dateLimite) throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        Promotion tempPromo = new Promotion();
        conn = tempPromo.connect();
        
        if (!conn.getAutoCommit()) {
            conn.setAutoCommit(true);
        }
        
        String sql = "SELECT * FROM promotion WHERE id_vol = ? AND id_type_siege = ? ORDER BY date_fin ASC LIMIT 1 OFFSET 1";
        ps = conn.prepareStatement(sql);
        ps.setString(1, idVol);
        ps.setString(2, idTypeSiege);
        
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String idPromotion = rs.getString("id_promotion");
            int nbSiegeActuel = rs.getInt("nb_siege");
            int nouveauNbSiege = nbSiegeActuel + placesARedonner;
            
            System.out.println("Redistribution vers promotion suivante " + idPromotion + ": " + 
                             nbSiegeActuel + " + " + placesARedonner + " = " + nouveauNbSiege);
            
            ps.close();
            String updateSql = "UPDATE promotion SET nb_siege = ? WHERE id_promotion = ?";
            ps = conn.prepareStatement(updateSql);
            ps.setInt(1, nouveauNbSiege);
            ps.setString(2, idPromotion);
            
            int updated = ps.executeUpdate();
            
            if (!conn.getAutoCommit()) {
                conn.commit();
            }
            
            if (updated > 0) {
                System.out.println("Places redistribuées vers " + idPromotion);
            }
        }
        rs.close();
        
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
}
    
    private int nettoyerPromotionsExpirees(Timestamp dateLimite) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        int count = 0;
        
        try {
            Promotion tempPromo = new Promotion();
            conn = tempPromo.connect();
            
            String sql = "UPDATE promotion SET nb_siege = 0 WHERE date_fin < ? AND nb_siege > 0";
            ps = conn.prepareStatement(sql);
            ps.setTimestamp(1, dateLimite);
            
            count = ps.executeUpdate();
            System.out.println("Promotions expirées nettoyées: " + count);
            
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        
        return count;
    }
}