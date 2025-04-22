package itu.project.aeroport.controller;


import java.time.Duration;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import itu.project.aeroport.model.vol.Vol;
import itu.project.aeroport.service.VolService;

@Controller
@RequestMapping("/vols")
public class VolController {
    private final VolService volService;

    public VolController(VolService vol){
        this.volService = vol;
    }

    @GetMapping("/")
    public String listAll(Model model){
        Vol[] vols  = volService.listAll();
        model.addAttribute("listVols", vols);
        model.addAttribute("listVilles",Context.getVilles());
        model.addAttribute("liste","vol");
        return "liste";
    }
    
    @PostMapping("/search")
    public String search(Model model,@ModelAttribute Vol vol, @RequestParam("minDuration") Duration minDuration,@RequestParam("maxDuration")Duration maxDuration){
        Vol[] vols = volService.search(vol,minDuration,maxDuration);
        model.addAttribute("listeVols", vols);
        model.addAttribute("listVilles",Context.getVilles());
        model.addAttribute("liste", "vol");
        return "liste";
    }
}
