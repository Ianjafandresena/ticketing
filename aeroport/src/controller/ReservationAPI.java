package controller;

import aeroport.reservation.Client;
import aeroport.reservation.Reservation;
import aeroport.reservation.CategoriePassager;
import mg.itu.annotation.ControlleurAnnotation;
import mg.itu.annotation.Get;
import mg.itu.annotation.Param;
import mg.itu.annotation.RequestBody;
import mg.itu.annotation.RestAPI;
import mg.itu.annotation.Url;
import mg.itu.utils.Exportation;
import mg.itu.utils.ModelView;
import mg.itu.utils.exception.BadRequestException;
import tools.ReservationExport;

@ControlleurAnnotation(url="/api/reservation")
public class ReservationAPI {
    @Get
    @RestAPI
    @Url(url="/listAPIReservation")
    public ModelView getList(@RequestBody(name="client") Client client) throws Exception{
        Reservation[] list;
        ModelView mv = new ModelView();
        if(client.getId_client() == "" || client.getId_client().equals("any")){
            list = Reservation.listAll();
        } else{
            Reservation r = new Reservation();
            r.setIdClient(client.getId_client());
            Object[] obj = r.find(null,r,null,null,"");
            list = new Reservation[obj.length];
            for(int i = 0; i< obj.length; i++){
                list[i] = (Reservation)obj[i];
                list[i].setClasse();
                list[i].setCli();
            }
        }
        mv.addObject("reservations", list);
        return mv;
    }

    @Get
    @RestAPI
    @Url(url="/categoriePassager")
    public ModelView getCategorieList() throws Exception{
        CategoriePassager[] passager = new CategoriePassager().getAll();
        ModelView mv = new ModelView();
        mv.addObject("list",passager);
        return mv;
    }

    @Get
    @RestAPI
    @Url(url="/export")
    public Exportation export(@Param(name="id")String id_reservation,@Param(name="type")String type) throws Exception{
        ReservationExport export = new ReservationExport();

        Reservation r = new Reservation();
        r.setIdReservation(id_reservation);
        Object[] obj = r.find(null, r, null, null, "");
        if(obj.length == 0) throw new BadRequestException(String.format("La reservation %s n'a pas été trouvée", id_reservation));
        r = (Reservation)obj[0];
        r.setClasse();
        r.setCli();

        System.out.println(export.getBytes());

        export.setType(type);
        export.setReservation(r);
        export.export();

        System.out.println(export.getBytes());

        return export;

    }
}
