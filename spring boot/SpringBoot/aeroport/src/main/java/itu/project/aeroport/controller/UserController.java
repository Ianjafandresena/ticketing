package itu.project.aeroport.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import itu.project.aeroport.model.users.Role;
import itu.project.aeroport.model.users.Users;
import itu.project.aeroport.service.RoleUsersService;
import itu.project.aeroport.service.UserService;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
    private final UserService userService;
    private final RoleUsersService roleService;

    public UserController(UserService user,RoleUsersService serv){
        this.userService = user;
        this.roleService = serv;
    }

    @PostMapping("/login")
    public String login(@RequestParam String login, @RequestParam String password, Model model,HttpSession session, RedirectAttributes redirect){
        Users u = userService.login(password, login);
        if(u == null){
            redirect.addFlashAttribute("message","Wrong information was provided");
            return "redirect:/login";
        }
        session.setAttribute("user", u);
        Role[] roles = roleService.getAll(u);
        session.setAttribute("isAdmin",Role.verif(roles, "admin"));
        for(Role r : roles){
            System.out.println(r.getDesignation());
        }
        session.setAttribute("roles", roles);
        return "home";
    }

    @GetMapping("/login")
    public String redirectLogin(){
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session){
        session.removeAttribute("user");
        return "login";
    }

    @GetMapping("/home")
    public String home(){
        return "home";
    }
}
