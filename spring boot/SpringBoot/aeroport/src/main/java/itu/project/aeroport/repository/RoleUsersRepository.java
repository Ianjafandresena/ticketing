package itu.project.aeroport.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import itu.project.aeroport.model.id.IdRoleUsers;
import itu.project.aeroport.model.users.RoleUsers;
import itu.project.aeroport.model.users.Users;

public interface RoleUsersRepository extends JpaRepository<RoleUsers,IdRoleUsers>{
    List<RoleUsers> findByUser(Users user);
}
