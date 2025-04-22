package itu.project.aeroport.model.reservation;

public class Reduction {
    String idCategoriePassager;
    double pourcentage;
    String dateApplication;
    public String getDateApplication() {
        return dateApplication;
    }
    public void setDateApplication(String dateApplication) {
        this.dateApplication = dateApplication;
    }
    public String getIdCategoriePassager() {
        return idCategoriePassager;
    }
    public void setIdCategoriePassager(String idCategoriePassager) {
        this.idCategoriePassager = idCategoriePassager;
    }
    public double getPourcentage() {
        return pourcentage;
    }
    public void setPourcentage(double pourcentage) {
        this.pourcentage = pourcentage;
    }
}
