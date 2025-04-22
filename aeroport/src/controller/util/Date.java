package controller.util;

import java.sql.Timestamp;

import mg.itu.annotation.type.DateSQL;
import mg.itu.annotation.type.Numeric;

public class Date {
    @DateSQL(type="timestamp",format = "yyyy-MM-dd HH:mm:ss")
    Timestamp date;
    @Numeric
    int heure;
    @Numeric
    int minute;
    public Timestamp getDate() {
        return date;
    }
    public void setDate(Timestamp date) {
        this.date = date;
    }
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

}
