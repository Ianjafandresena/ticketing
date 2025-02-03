package aeroport.vol;

import java.sql.Timestamp;
import java.util.ArrayList;

import org.postgresql.util.PGInterval;

import aeroport.Ville;
import aeroport.avion.Avion;
import aeroport.avion.Avion_place;
import aeroport.reservation.Reservation;
import aeroport.reservation.utils.Reservation_utils;
import mg.itu.annotation.type.DateSQL;
import mg.itu.annotation.type.Text;
import utility.DateConverter;
import utility.Entity;
import utility.annotation.Column;
import utility.annotation.Ignore;
import utility.annotation.Table;

@Table(name="vol")
public class Vol extends Entity<Vol>{
    @Column(name="id_vol")
    String idVol;
    @Text
    String depart;
    @DateSQL(format = "yyyy-MM-dd HH:mm:ss",type = "timestamp")
    @Column(name="date_depart")
    Timestamp dateDepart;
    @Text
    PGInterval duree_vol;
    @Text
    String destination;

    @Ignore
    Vol_avion[] avions;
    @Ignore
    Vol_tarif[] tarifs;
    @Ignore
    Vol_tarif[] apresProm;
    @Ignore 
    String dureeV;
    @Ignore
    String dateString;
    @Ignore 
    String departV;
    @Ignore 
    String destinationV;

    @Ignore 
    int dispoB;
    @Ignore
    int dispoE;

    public int getDispoB() {
        return dispoB;
    }

    public int getDispoE() {
        return dispoE;
    }

    public void setDispo() throws Exception{
        dispoB = countSiegeDispo("TYP000001");
        dispoE = countSiegeDispo("TYP000002");
    }

    public String getIdVol() {
        return idVol;
    }

    public void setIdVol(String id_vol) {
        if(id_vol != null && id_vol.equals("")) return;
        this.idVol = id_vol;
    }
    public String getDepart() {
        return depart;
    }
    public void setDepart(String depart) {
        this.depart = depart;
        try{
            Ville v = new Ville();
            v.setId_ville(depart);
            Object[] o = v.find(null,v,null,null,"");
            if(o.length != 0) departV = ((Ville)o[0]).getDesignation();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public Timestamp getDateDepart() {
        return dateDepart;
    }
    public String getDateString() throws Exception{
        return DateConverter.timestampToString(dateDepart);
    }
    public void setDateDepart(Timestamp date_depart) {
        this.dateDepart = date_depart;
        try{
            dateString = DateConverter.timestampToString(date_depart);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public PGInterval getDuree_vol() {
        return duree_vol;
    }
    public void setDuree_vol(PGInterval duree) {
        this.duree_vol = duree;
        try{
            int h = duree_vol.getHours();
            int m = duree_vol.getMinutes();
            String ajoutH = "";
            String ajoutM = ""; 
            if(h < 10) ajoutH = "0";
            if(m < 10) ajoutM = "0";

            dureeV = ajoutH+h+":"+ajoutM+m;

        } catch(Exception e){
            e.printStackTrace();
        }
    }
    public String getDureeV(){
        return dureeV;
    }
    public void setDuree_vol(String duree) throws Exception{
        this.duree_vol = new PGInterval(duree);
    }
    public Vol_avion[] getAvions() {
        return avions;
    }
    public void setAvions(Vol_avion[] avions) {
        this.avions = avions;
    }
    public Vol_tarif[] getTarifs() throws Exception{
        if(tarifs == null) setTarifs();
        return tarifs;
    }
    public void setTarifs() throws Exception{
        Vol_tarif vt = new Vol_tarif();
        vt.setId_vol(idVol);
        Object[] obj = vt.find(null,vt,null,null,"");
        this.tarifs = new Vol_tarif[obj.length];
        for(int i = 0; i<obj.length; i++){
            tarifs[i] = (Vol_tarif)obj[i];
        }
    }
    public String getDestination() {
        return destination;
    }
    public void setDestination(String destination) {
        this.destination = destination;
        try{
            Ville v = new Ville();
            v.setId_ville(destination);
            Object[] o = v.find(null,v,null,null,"");
            if(o.length != 0) destinationV = ((Ville)o[0]).getDesignation();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public String getDestinationV() throws Exception{
        return destinationV;
    }
    public String getDepartV() throws Exception{
        return departV;
    }

    public Vol(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }

    public int countSiegeDispo(String typeSiege) throws Exception{
        int res = 0;

        Vol v = new Vol();
        v.setIdVol(idVol);
        Vol_avion va = new Vol_avion();
        Avion a = new Avion();
        Avion_place  ap = new Avion_place();
        ap.setId_type_siege(typeSiege);

        v.join(va,"id_vol","id_vol","=","");
        v.join(a,"vol_avion.id_avion","id_avion","=","");
        v.join(ap,"avion.id_avion","id_avion","=","");
        v.join(new Reservation(),"vol.id_vol,avion_place.id_type_siege","id_vol,id_type_siege","=,=","LEFT");

        ArrayList<String> targetColumn = new ArrayList<>();
        targetColumn.add("(COALESCE(avion_place.nb - COALESCE(SUM(reservation.nb_enfant + reservation.nb_adulte),0))) as nb");
        Reservation_utils util = new Reservation_utils();

        util = (Reservation_utils)v.find(targetColumn,util,null,null," GROUP BY avion_place.nb")[0];

        res = util.getNb().intValue();

        return res;
    }
    
}
