package itu.project.aeroport.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import itu.project.aeroport.model.reservation.CategoriePassager;
import itu.project.aeroport.model.reservation.Reduction;
import itu.project.aeroport.service.API.CategoriePassagerService;
import itu.project.aeroport.service.API.ReductionService;

@Controller
@RequestMapping("/reduction")
public class ReductionController {
    private final ReductionService rServ;
    private final CategoriePassagerService pServ;

    public ReductionController(ReductionService rServ,CategoriePassagerService pServ){
        this.rServ = rServ;
        this.pServ = pServ;
    }

    @GetMapping("/form")
    public String redirectFormInsert(Model model){
        Reduction r = new Reduction();
        CategoriePassager[] categories = pServ.getList();
        model.addAttribute("reduction", r);
        model.addAttribute("categories",categories);
        model.addAttribute("form","reduction");

        return "form";
    }

    @PostMapping("/insert")
    public String insert(@ModelAttribute Reduction reduction,RedirectAttributes redirect){
        String message = rServ.insertReduction(reduction);
        redirect.addFlashAttribute("message", message);
        return "redirect:/reduction/form";
    }
}
