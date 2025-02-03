package aeroport.reservation;

import java.sql.Timestamp;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import aeroport.avion.Type_siege;
import aeroport.reservation.utils.Reservation_utils;
import aeroport.vol.Promotion;
import aeroport.vol.Vol;
import aeroport.vol.Vol_tarif;
import mg.itu.annotation.type.DateSQL;
import mg.itu.annotation.type.Numeric;
import mg.itu.annotation.type.Text;
import utility.DateConverter;
import utility.Entity;
import utility.annotation.Column;
import utility.annotation.Ignore;
import utility.annotation.Table;

@Table(name="reservation")
public class Reservation extends Entity<Reservation>{
    @Text
    @Column(name="id_reservation")
    String idReservation;
    
    @Text
    @Column(name="id_vol")
    String idVol;

    @Text
    @Column(name="id_type_siege")
    String idTypeSiege;

    @Numeric
    @Column(name="nb_enfant")
    Integer nbEnfant;

    @Numeric
    @Column(name="nb_adulte")
    Integer nbAdulte;

    Double prix;

    @Text
    @Column(name="id_client")
    String idClient;

    @DateSQL(type="timestamp",format = "yyyy-MM-dd HH:mm:ss")
    @Column(name="date_reservation")
    Timestamp dateReservation;

    @Text
    @Column(name="status")
    String status;

    @Ignore
    Promotion promotion;
    @Ignore
    Vol vol;

    @Ignore
    Vol_tarif tarif;
    @Ignore
    Client cli;
    @Ignore 
    String classe;
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isPending() {
        return "pending".equals(status);
    }

    public boolean isConfirmed() {
        return "confirmed".equals(status);
    }

    public boolean isCancelled() {
        return "cancelled".equals(status);
    }

    public void markAsPaid() throws Exception {
    Connection conn = null;
    java.sql.PreparedStatement ps = null;
    try {
        conn = this.connect();
        
        // Forcer l'autocommit
        if (!conn.getAutoCommit()) {
            System.out.println("AutoCommit désactivé, activation...");
            conn.setAutoCommit(true);
        }
        
        String sql = "UPDATE reservation SET status = ? WHERE id_reservation = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, "confirmed");
        ps.setString(2, this.idReservation);
        
        int rowsUpdated = ps.executeUpdate();
        System.out.println("Lignes mises à jour: " + rowsUpdated);
        
        // Forcer le commit si nécessaire
        if (!conn.getAutoCommit()) {
            conn.commit();
            System.out.println("Transaction commitée");
        }
        
        if (rowsUpdated > 0) {
            this.status = "confirmed";
            System.out.println("Statut mis à jour vers: " + this.status);
        } else {
            throw new Exception("Aucune ligne mise à jour pour réservation: " + this.idReservation);
        }
        
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
}

    public void markAsCancelled() throws Exception {
    Connection conn = null;
    java.sql.PreparedStatement ps = null;
    try {
        conn = this.connect();
        
        if (!conn.getAutoCommit()) {
            conn.setAutoCommit(true);
        }
        
        String sql = "UPDATE reservation SET status = ? WHERE id_reservation = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, "cancelled");
        ps.setString(2, this.idReservation);
        
        int rowsUpdated = ps.executeUpdate();
        
        if (!conn.getAutoCommit()) {
            conn.commit();
        }
        
        if (rowsUpdated > 0) {
            this.status = "cancelled";
        } else {
            throw new Exception("Aucune ligne mise à jour pour réservation: " + this.idReservation);
        }
        
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
}

    public String getStatusDisplay() {
        if (status == null) return "En attente";
        switch (status) {
            case "pending":
                return "En attente";
            case "confirmed":
                return "Payé";
            case "cancelled":
                return "Annulé";
            default:
                return "Inconnu";
        }
    }

    public String getStatusClass() {
        if (status == null) return "warning";
        switch (status) {
            case "pending":
                return "warning";
            case "confirmed":
                return "success";
            case "cancelled":
                return "danger";
            default:
                return "secondary";
        }
    }
    
    public Vol getVol() {
        return vol;
    }
    
    public Promotion getPromotion() {
        return promotion;
    }
    
    public Client getCli() {
        return cli;
    }
    public void setCli() throws Exception{
        if(idClient == null) return;
        Client c = new Client();
        c.setId_client(idClient);
        Object[] o = c.find(null,c,null,null,"");
        if(o.length == 0) return;
        this.cli = (Client)o[0];
    }
    public String getClasse() {
        return classe;
    }
    public void setClasse() throws Exception{
        Type_siege ts = new Type_siege();
        ts.setId_type_siege(idTypeSiege);
        Object[] o = ts.find(null,ts,null,null,"");
        if(o.length == 0) return;
        this.classe = ((Type_siege)o[0]).getDesignation();
    }
    public String getIdReservation() {
        return idReservation;
    }
    public void setIdReservation(String id_reservation) {
        this.idReservation = id_reservation;
    }
    public String getIdVol() {
        return idVol;
    }
    public void setIdVol(String id_vol) throws Exception{
        this.idVol = id_vol;
        if(id_vol != null && this.vol == null){
            Vol v = new Vol();
            v.setIdVol(id_vol);
            Object[] obj = v.find(null, v, null, null, "");
            if(obj.length != 0) v = (Vol)obj[0];
            this.vol = v;
        }
    }
    public String getIdTypeSiege() {
        return idTypeSiege;
    }
    public void setIdTypeSiege(String id_type_siege) {
        this.idTypeSiege = id_type_siege;
    }
    public Integer getNbEnfant() {
        return nbEnfant;
    }
    public void setNbEnfant(Integer nb) {
        this.nbEnfant = nb;
    }
    public Integer getNbAdulte() {
        return nbAdulte;
    }
    public void setNbAdulte(Integer nb) {
        this.nbAdulte = nb;
    }
    public Double getPrix() {
        return prix;
    }
    public void setPrix(Double prix) {
        this.prix = prix;
    }
    public String getIdClient() {
        return idClient;
    }
    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }
    public Timestamp getDateReservation() {
        return dateReservation;
    }
    public String getDateString() throws Exception{
        return DateConverter.timestampToString(dateReservation);
    }
    public void setDateReservation(Timestamp dateReservation) {
        this.dateReservation = dateReservation;
    }

    public Reservation(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public double getTarif() throws Exception{
        Connection conn = null;
        try{
            conn = this.connect();
            if(promotion == null) setPromotion();
            
            double res = 0;
            
            // Obtenir les tarifs unitaires
            double tarifAdulteUnitaire = getVol_tarif().getTarif(false, conn, this.dateReservation);
            double tarifEnfantUnitaire = getVol_tarif().getTarif(true, conn, this.dateReservation);
            
            // Calcul de la réduction de promotion
            double reduc = 0;
            if(promotion != null) reduc = promotion.getPourcentage();
            
            // Calculer combien de personnes bénéficient de la promotion
            int restProm = getPromotionRestant();
            int enPromo = nbEnfant + nbAdulte;
            if(restProm < (nbEnfant + nbAdulte)){
                enPromo = restProm;
            }

            // LOGS DE DEBUG DÉTAILLÉS
            System.out.println("=================== DEBUG CALCUL TARIF ===================");
            System.out.println("Vol: " + idVol + " | Type siège: " + idTypeSiege);
            System.out.println("Nombre adultes: " + nbAdulte + " | Nombre enfants: " + nbEnfant);
            System.out.println("Date réservation: " + dateReservation);
            System.out.println("Tarif adulte unitaire (avant promotion): " + tarifAdulteUnitaire);
            System.out.println("Tarif enfant unitaire (avant promotion): " + tarifEnfantUnitaire);
            System.out.println("Promotion applicable: " + (promotion != null ? promotion.getPourcentage() + "%" : "aucune"));
            System.out.println("Personnes en promotion: " + enPromo + "/" + (nbEnfant + nbAdulte));
            System.out.println("Réduction: " + reduc + "%");
            System.out.println("--------------------------------------------------------");
            
            // Calcul pour chaque adulte
            double totalAdultes = 0;
            for(int i = 0; i < nbAdulte; i++){
                double tarifIndividuel;
                if(i < enPromo - 1){
                    tarifIndividuel = tarifAdulteUnitaire * (1 - reduc/100);
                    System.out.println("Adulte " + (i+1) + " (avec promotion): " + tarifIndividuel);
                } else{
                    tarifIndividuel = tarifAdulteUnitaire;
                    System.out.println("Adulte " + (i+1) + " (sans promotion): " + tarifIndividuel);
                }
                totalAdultes += tarifIndividuel;
                res += tarifIndividuel;
            }
            
            // Calcul pour chaque enfant
            double totalEnfants = 0;
            for(int i = 0; i < nbEnfant; i++){
                double tarifIndividuel;
                if(i < enPromo - 1){
                    tarifIndividuel = tarifEnfantUnitaire * (1 - reduc/100);
                    System.out.println("Enfant " + (i+1) + " (avec promotion): " + tarifIndividuel);
                } else{
                    tarifIndividuel = tarifEnfantUnitaire;
                    System.out.println("Enfant " + (i+1) + " (sans promotion): " + tarifIndividuel);
                }
                totalEnfants += tarifIndividuel;
                res += tarifIndividuel;
            }

            System.out.println("--------------------------------------------------------");
            System.out.println("Total adultes: " + totalAdultes);
            System.out.println("Total enfants: " + totalEnfants);
            System.out.println("PRIX TOTAL FINAL: " + res);
            System.out.println("Moyenne par personne: " + (res / (nbAdulte + nbEnfant)));
            System.out.println("=======================================================");

            return res;
        }catch(Exception e){
            throw e;
        }finally{
            if(conn != null) conn.close();
        }
    }

    public int getPromotionRestant() throws Exception{
        if(promotion == null) setPromotion();
        if(promotion == null) return 0; //si il n'y a pas de promotion
        Reservation r = new Reservation();
        r.setIdVol(idVol);
        r.setIdTypeSiege(idTypeSiege);
        ArrayList<String> targetColumn = new ArrayList<>();
        ArrayList<String> ecartLabel = new ArrayList<>();
        ArrayList<Map<String, Object>> ecartValue = new ArrayList<>();
        ecartLabel.add("date_reservation");
        Map<String,Object> dr = new HashMap<>();
        dr.put("max",promotion.getDateFin());
        dr.put("min",promotion.getDateDebut());
        ecartValue.add(dr);
        String select = "("+promotion.getNbSiege() + "- COALESCE(SUM(reservation.nb_enfant + reservation.nb_adulte),0)"+") as nb";
        targetColumn.add(select);
        Reservation_utils ru = new Reservation_utils();
        ru = (Reservation_utils)r.find(targetColumn,ru,ecartLabel,ecartValue,"")[0];

        if(ru.getNb() < 0) return 0;
        return ru.getNb().intValue();
    }

    public void setVol() throws Exception{
        Vol v = new Vol();
        v.setIdVol(idVol);
        Object[] vs = v.find(null,v,null,null,"");
        if(vs.length == 0) return;
        vol = (Vol)vs[0];
    }

    public void setPromotion() throws Exception{
    if(vol == null) setVol();
    Promotion p = new Promotion();
    p.setIdTypeSiege(idTypeSiege);
    p.setIdVol(idVol);
    ArrayList<String> ecartLabel = new ArrayList<>();
    ArrayList<Map<String,Object>> ecartValue = new ArrayList<>();
    
    // Seulement vérifier la date de fin (plus de date_debut)
    ecartLabel.add("date_fin");
    Map<String,Object> df = new HashMap<>();
    df.put("min", getDateReservation()); // La réservation doit être avant la fin de la promotion
    ecartValue.add(df);
    
    Object[] obj = p.find(null, p, ecartLabel, ecartValue, " ORDER BY date_fin DESC LIMIT 1");
    if(obj.length == 0) {
        promotion = null;
        return;
    }
    promotion = (Promotion)obj[0];
    
    System.out.println("Promotion trouvée: prix=" + promotion.getPrixPromotion() + "€, fin=" + promotion.getDateFin());
}

    public Vol_tarif getVol_tarif() throws Exception{
        if(tarif != null) return tarif;
        Vol_tarif vt = new Vol_tarif();
        vt.setIdTypeSiege(idTypeSiege);
        vt.setId_vol(idVol);
        tarif = (Vol_tarif)vt.find(null,vt,null,null,"")[0];
        return tarif;
    }

    public boolean canAnnulate(String dateAnnulation) throws Exception{
        if(vol == null) setVol();
        LimitAnnulation la = new LimitAnnulation();
        la.setIdVol(idVol);

        ArrayList<String> ecartLabel = new ArrayList<>();
        ArrayList<Map<String,Object>> ecartValue = new ArrayList<>();
        ecartLabel.add("date_application");
        Map<String,Object> value = new HashMap<>();
        value.put("max",vol.getDateDepart());
        ecartValue.add(value);

        Object[] obj = la.find(null,la,ecartLabel,ecartValue," ORDER BY date_application DESC LIMIT 1");
        if(obj.length == 0) {
            obj = new LimitAnnulation().find(null,new LimitAnnulation(),ecartLabel,ecartValue," ORDER BY date_application DESC LIMIT 1");
            if(obj.length == 0) return true;
        }
        la = (LimitAnnulation)obj[0];
        Timestamp dateAnn = DateConverter.stringToTimestamp(dateAnnulation);
        return la.isRespect(dateAnn, vol.getDateDepart());
    }

    public boolean isValid() throws Exception{
        if(vol == null) setVol();
        int siegeDispo = vol.countSiegeDispo(idTypeSiege);
        LimitReservation lr = new LimitReservation();
        lr.setIdVol(idVol);

        ArrayList<String> ecartLabel = new ArrayList<>();
        ArrayList<Map<String,Object>> ecartValue = new ArrayList<>();
        ecartLabel.add("date_application");
        Map<String,Object> value = new HashMap<>();
        value.put("max",vol.getDateDepart());
        ecartValue.add(value);

        Object[] obj = lr.find(null,lr,ecartLabel,ecartValue," ORDER BY date_application DESC LIMIT 1");
        boolean valid = false;
        if(obj.length == 0){
            obj = new LimitReservation().find(null,new LimitReservation(),ecartLabel,ecartValue," ORDER BY date_application DESC LIMIT 1");
            if(obj.length == 0) valid = true;
            else {
                lr = (LimitReservation)obj[0];
                valid = lr.isRespect(dateReservation, vol.getDateDepart());
            }
        }
        else{
            lr = (LimitReservation)obj[0];
            valid = lr.isRespect(dateReservation, vol.getDateDepart());
        }
        boolean validD = vol.getDateDepart().after(this.getDateReservation());
        
        return siegeDispo >= (nbEnfant+nbAdulte) && valid && validD;
    }

    public static Reservation[] listAll() throws Exception{
        Reservation r = new Reservation();
        Reservation[] all = r.getAll();
        for(Reservation re : all){
            re.setCli();
            re.setClasse();
        }
        return all;
    }

    public void updatePromotionAfterReservation() throws Exception {
        if (promotion == null) setPromotion();
        if (promotion == null) return; // Pas de promotion active
        
        // Calculer combien de personnes ont bénéficié de la promotion
        int totalPersonnes = (nbAdulte != null ? nbAdulte : 0) + (nbEnfant != null ? nbEnfant : 0);
        int siegesPromoRestants = getPromotionRestant();
        
        // Le nombre de personnes qui ont effectivement bénéficié de la promotion
        int personnesEnPromo = Math.min(totalPersonnes, siegesPromoRestants + totalPersonnes);
        
        if (personnesEnPromo > 0) {
            System.out.println("Diminution de " + personnesEnPromo + " sièges de la promotion " + promotion.getId_promotion());
            promotion.decreaseNbSiege(personnesEnPromo);
        }
    }
}