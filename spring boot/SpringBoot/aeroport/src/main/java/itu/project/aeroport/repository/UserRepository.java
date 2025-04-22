package itu.project.aeroport.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import itu.project.aeroport.model.users.Users;

@Repository
public interface UserRepository extends JpaRepository<Users,String>{
    
    @Query(value = "SELECT * FROM users WHERE login = :login AND password = crypt(:password,password)", nativeQuery = true)
    Users login(@Param("login")String login,@Param("password") String password);


}
