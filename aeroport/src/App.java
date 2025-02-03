import aeroport.reservation.Reservation;
import aeroport.vol.Vol;
import utility.DateConverter;

public class App {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello, World!");
        try{
            Vol a = new Vol();
            a.setIdVol("VOL000001");
            System.out.println(a.countSiegeDispo("TYP000002"));
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
