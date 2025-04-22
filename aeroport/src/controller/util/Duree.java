package controller.util;

import org.postgresql.util.PGInterval;

import mg.itu.annotation.type.Numeric;

public class Duree {
    @Numeric
    int heure;
    @Numeric
    int minute;
    public int getHeure() {
        return heure;
    }
    public void setHeure(int heure) {
        this.heure = heure;
    }
    public int getMinute() {
        return minute;
    }
    public void setMinute(int minute) {
        this.minute = minute;
    }

    public String toInterval(){
        String plusH = "";
        String plusM = "";
        if(heure < 10) plusH = "0";
        if(minute < 10) plusM = "0";
        return plusH+heure + ":"+plusM+minute+" :00";
    }

    public PGInterval toIntervalPG() throws Exception{
        return new PGInterval(toInterval());
    }
    
}
