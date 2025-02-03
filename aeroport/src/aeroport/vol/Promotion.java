package aeroport.vol;

import java.sql.Connection;
import java.sql.Timestamp;

import mg.itu.annotation.type.DateSQL;
import mg.itu.annotation.type.Numeric;
import mg.itu.annotation.type.Text;
import utility.Entity;
import utility.annotation.Column;
import utility.annotation.Table;

@Table(name="promotion")
public class Promotion extends Entity<Promotion>{
    String id_promotion;
    
    @Column(name="id_vol")
    @Text
    String idVol;

    @Numeric
    @Column(name="prix_promotion")
    Double prixPromotion;
    
    @Text
    @Column(name="id_type_siege")
    String idTypeSiege;

    @DateSQL(type="timestamp",format = "yyyy-MM-dd HH:mm:ss")
    @Column(name="date_fin")
    Timestamp dateFin;

    @Column(name="nb_siege")
    @Numeric
    Integer nbSiege;

    
    
    public String getId_promotion() {
        return id_promotion;
    }
    public void setId_promotion(String id_promotion) {
        this.id_promotion = id_promotion;
    }
    public String getIdVol() {
        return idVol;
    }
    public void setIdVol(String idVol) {
        this.idVol = idVol;
    }
    public Double getPrixPromotion() {
        return prixPromotion;
    }
    public void setPrixPromotion(Double prixPromotion) {
        this.prixPromotion = prixPromotion;
    }
    
    // Méthode de compatibilité pour le code existant qui utilise getPourcentage()
    public Double getPourcentage() {
        // Retourner 0 pour indiquer qu'aucun pourcentage n'est utilisé
        return 0.0;
    }
    
    public String getIdTypeSiege() {
        return idTypeSiege;
    }
    public void setIdTypeSiege(String idTypeSiege) {
        this.idTypeSiege = idTypeSiege;
    }
    
    // Méthode de compatibilité pour le code existant qui utilise getDateDebut()
    public Timestamp getDateDebut() {
        // Retourner la date actuelle comme début implicite
        return new Timestamp(System.currentTimeMillis());
    }
    
    public Timestamp getDateFin() {
        return dateFin;
    }
    public void setDateFin(Timestamp dateFin) {
        this.dateFin = dateFin;
    }
    public Integer getNbSiege() {
        return nbSiege;
    }
    public void setNbSiege(Integer nbSiege) {
        this.nbSiege = nbSiege;
    }

    public Promotion(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }

    public boolean isValid() throws Exception{
        Vol v = new Vol();
        v.setIdVol(idVol);
        Object[] o = v.find(null,v,null,null,"");
        if(o.length == 0) throw new Exception("Le vol "+idVol+" n'existe pas");
        v = (Vol)o[0];
        
        // Vérifier que la date de fin est après maintenant et avant le départ du vol
        Timestamp maintenant = new Timestamp(System.currentTimeMillis());
        return dateFin.after(maintenant) && v.getDateDepart().after(dateFin);
    }

    public void decreaseNbSiege(int nombreUtilise) throws Exception {
    Connection conn = null;
    java.sql.PreparedStatement ps = null;
    try {
        conn = this.connect();
        
        // IMPORTANT: Forcer l'autocommit
        if (!conn.getAutoCommit()) {
            System.out.println("AutoCommit désactivé pour promotion, activation...");
            conn.setAutoCommit(true);
        }
        
        // Vérifier le nombre actuel
        String selectSql = "SELECT nb_siege FROM promotion WHERE id_promotion = ?";
        ps = conn.prepareStatement(selectSql);
        ps.setString(1, this.id_promotion);
        java.sql.ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            int nbActuel = rs.getInt("nb_siege");
            int nouveauNb = Math.max(0, nbActuel - nombreUtilise);
            
            System.out.println("Promotion " + this.id_promotion + ": " + nbActuel + " -> " + nouveauNb + " sièges");
            
            // Mettre à jour
            ps.close();
            String updateSql = "UPDATE promotion SET nb_siege = ? WHERE id_promotion = ?";
            ps = conn.prepareStatement(updateSql);
            ps.setInt(1, nouveauNb);
            ps.setString(2, this.id_promotion);
            
            int rowsUpdated = ps.executeUpdate();
            
            // FORCER LE COMMIT si nécessaire
            if (!conn.getAutoCommit()) {
                conn.commit();
                System.out.println("Transaction promotion commitée");
            }
            
            if (rowsUpdated > 0) {
                this.nbSiege = nouveauNb;
                System.out.println("Nombre de sièges promotion mis à jour avec succès");
                
                // VÉRIFICATION : Relire depuis la base pour confirmer
                ps.close();
                ps = conn.prepareStatement("SELECT nb_siege FROM promotion WHERE id_promotion = ?");
                ps.setString(1, this.id_promotion);
                java.sql.ResultSet checkRs = ps.executeQuery();
                if (checkRs.next()) {
                    int verification = checkRs.getInt("nb_siege");
                    System.out.println("VÉRIFICATION en base : nb_siege = " + verification);
                } else {
                    System.out.println("ERREUR : Impossible de vérifier la mise à jour");
                }
                checkRs.close();
            } else {
                System.out.println("ERREUR : Aucune ligne mise à jour pour promotion " + this.id_promotion);
            }
        } else {
            System.out.println("ERREUR : Promotion " + this.id_promotion + " introuvable");
        }
        rs.close();
        
    } catch (Exception e) {
        System.err.println("Erreur lors de la diminution des sièges promotion: " + e.getMessage());
        e.printStackTrace();
        // En cas d'erreur, rollback si possible
        if (conn != null && !conn.getAutoCommit()) {
            try {
                conn.rollback();
                System.out.println("Rollback effectué pour la promotion");
            } catch (Exception rollbackEx) {
                System.err.println("Erreur lors du rollback: " + rollbackEx.getMessage());
            }
        }
        throw e;
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
}

public boolean isActive() {
    if (dateFin == null) return false;
    Timestamp maintenant = new Timestamp(System.currentTimeMillis());
    return maintenant.before(dateFin) && nbSiege > 0;
}

public String getStatutPromotion() {
    if (dateFin == null) return "Expirée";
    
    Timestamp maintenant = new Timestamp(System.currentTimeMillis());
    if (maintenant.after(dateFin)) {
        return "Expirée";
    } else if (nbSiege <= 0) {
        return "Épuisée";
    } else {
        return "Active (" + nbSiege + " sièges restants)";
    }
}

}