package itu.project.aeroport.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import itu.project.aeroport.model.reservation.Client;
import itu.project.aeroport.model.reservation.Reservation;
import itu.project.aeroport.model.users.Role;
import itu.project.aeroport.model.users.Users;
import itu.project.aeroport.service.ClientService;
import itu.project.aeroport.service.ReservationService;
import itu.project.aeroport.service.API.ReservationServiceAPI;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reservations")
public class ReservationController {
    private final ReservationService rService;
    private final ClientService sService;
    private final ReservationServiceAPI rServiveApi;

    public ReservationController(ReservationService res,ClientService client,ReservationServiceAPI rApi){
        this.rService = res;
        this.sService = client;
        this.rServiveApi = rApi;
    }

    @GetMapping("/")
    public String reservationList(Model model, HttpSession session){
        Reservation[] reservations = rService.getAll();
        Users u = (Users)session.getAttribute("user");
        Role[] r = (Role[])session.getAttribute("roles");
        if(!Role.verif(r,"admin")) {
            Client client = sService.getClient(u);
            reservations = rService.getByClient(client);
        }
        model.addAttribute("reservationList", reservations);
        model.addAttribute("page", "reservation");

        return "liste";
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> reservationList(@RequestParam("id") String id, @RequestParam("type") String type){
        return rServiveApi.export(id, type);
    }

}
