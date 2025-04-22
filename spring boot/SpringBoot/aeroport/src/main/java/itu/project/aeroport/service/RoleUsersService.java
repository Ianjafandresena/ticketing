package itu.project.aeroport.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import itu.project.aeroport.model.users.Role;
import itu.project.aeroport.model.users.RoleUsers;
import itu.project.aeroport.model.users.Users;
import itu.project.aeroport.repository.RoleUsersRepository;

@Service
public class RoleUsersService {
    @Autowired
    RoleUsersRepository repository;

    public Role[] getAll(Users user){
        List<RoleUsers> list = repository.findByUser(user);
        List<Role> listR = new ArrayList<>();

        for(RoleUsers ru : list){
            listR.add(ru.getRole());
        }
        return listR.toArray(new Role[0]);
    }
}
