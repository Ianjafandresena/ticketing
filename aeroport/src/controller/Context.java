package controller;

import aeroport.Ville;
import aeroport.avion.Avion;
import aeroport.avion.Type_siege;

public class Context {
    static Ville[] villes;
    static Type_siege[] sieges;
    static Avion[] avions;

    public static void setVilles() throws Exception{
        Context.villes = new Ville().getAll();;
    }

    public static void setSieges() throws Exception{
        Context.sieges = new Type_siege().getAll();;
    }

    public static void setAvions() throws Exception{
        Context.avions = new Avion().getAll();
    }

    public static void initContext(){
        try{
            setVilles();
            setAvions();
            setSieges();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public static Ville[] getVilles() throws Exception{
        if(villes == null) setVilles();
        return villes;
    }
    public static Type_siege[] getSieges() throws Exception{
        if(sieges == null) setSieges();
        return sieges;
    }
    public static Avion[] getAvions() throws Exception{
        if(avions == null) setAvions();
        return avions;
    }


}
