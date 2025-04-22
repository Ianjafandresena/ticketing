package itu.project.aeroport.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import itu.project.aeroport.model.users.Users;
import itu.project.aeroport.repository.UserRepository;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;

    public Users login(String password,String login){
        return userRepository.login(login,password);
    }
}
