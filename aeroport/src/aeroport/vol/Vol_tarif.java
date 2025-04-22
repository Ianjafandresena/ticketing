package aeroport.vol;

import java.sql.Connection;
import mg.itu.annotation.type.Numeric;
import mg.itu.annotation.type.Text;
import utility.Entity;
import utility.annotation.Column;
import utility.annotation.Table;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import java.sql.Timestamp;

@Table(name="vol_tarif")
public class Vol_tarif extends Entity<Vol_tarif>{
    Integer id_vol_tarif;
    @Text
    String id_vol;
    @Numeric
    Double tarif;
    @Text
    @Column(name="id_type_siege")
    String idTypeSiege;
    
    public Integer getId_vol_tarif() {
        return id_vol_tarif;
    }
    public void setId_vol_tarif(Integer id_vol_tarif) {
        this.id_vol_tarif = id_vol_tarif;
    }
    public String getId_vol() {
        return id_vol;
    }
    public void setId_vol(String id_vol) {
        this.id_vol = id_vol;
    }
    public Double getTarif() {
        return tarif;
    }
    public void setTarif(Double tarif) {
        this.tarif = tarif;
    }
    public String getIdTypeSiege() {
        return idTypeSiege;
    }
    public void setIdTypeSiege(String id_type_siege) {
        this.idTypeSiege = id_type_siege;
    }

    public Vol_tarif(){
        try{
            initiate();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public Double getTarif(boolean isEnfant,Connection con,Timestamp date) throws Exception{
    double res = 0;
    Reduction r = new Reduction();
    double pourcent = 0;
    
    // Définition de la catégorie de passager (IDs codés en dur)
    r.setIdCategoriePassager("PRM000002"); // Adulte par défaut
    if(isEnfant) r.setIdCategoriePassager("PRM000001"); // Enfant

    // Recherche de la réduction applicable à la date donnée
    ArrayList<String> ecartLabel = new ArrayList<>();
    ArrayList<Map<String, Object>> ecartValue = new ArrayList<>();

    ecartLabel.add("date_application");
    Map<String,Object> val = new HashMap<>();
    val.put("max",date);
    ecartValue.add(val);

    Object[] obj = r.find(null,r,ecartLabel,ecartValue," ORDER BY date_application DESC",con);
    if(obj.length == 0) pourcent = 0;
    else pourcent = ((Reduction)obj[0]).getPourcentage();
    
    // Application de la réduction au tarif de base
    res = this.tarif * (1-pourcent/100);

    // DEBUG pour voir ce qui se passe
    System.out.println("=== DEBUG RÉDUCTION ===");
    System.out.println("Type passager: " + (isEnfant ? "Enfant" : "Adulte"));
    System.out.println("ID catégorie: " + r.getIdCategoriePassager());
    System.out.println("Pourcentage trouvé en base: " + pourcent + "%");
    System.out.println("Tarif de base: " + this.tarif);
    System.out.println("Tarif final: " + res);
    System.out.println("=======================");

    return res;
}
}