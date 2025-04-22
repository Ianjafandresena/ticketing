package controller;

import aeroport.reservation.Client;
import mg.itu.annotation.ControlleurAnnotation;
import mg.itu.annotation.Param;
import mg.itu.annotation.Post;
import mg.itu.annotation.Url;
import mg.itu.utils.ModelView;
import mg.itu.utils.MySession;
import java.io.InputStream;

@ControlleurAnnotation(url="/users")
public class Users {
    @Post
    @Url(url="/login")
    public ModelView login(MySession session,@Param(name="login") String login,@Param(name="password") String password){
        admin.Users user = new admin.Users();
        user.setLogin(login);
        user.setPassword(password);
        ModelView mv = new ModelView("home.jsp");
        
        // Debug du classpath
        System.out.println("=== DEBUG CONFIGURATION ===");
        try {
            InputStream test1 = getClass().getClassLoader().getResourceAsStream("app.conf");
            InputStream test2 = getClass().getClassLoader().getResourceAsStream("config.properties");
            InputStream test3 = getClass().getClassLoader().getResourceAsStream("app.properties");
            InputStream test4 = getClass().getClassLoader().getResourceAsStream("config/app.conf");
            System.out.println("app.conf trouvé: " + (test1 != null));
            System.out.println("config.properties trouvé: " + (test2 != null));
            System.out.println("app.properties trouvé: " + (test3 != null));
            System.out.println("config/app.conf trouvé: " + (test4 != null));
            if(test1 != null) test1.close();
            if(test2 != null) test2.close();
            if(test3 != null) test3.close();
            if(test4 != null) test4.close();
        } catch(Exception debugE) {
            debugE.printStackTrace();
        }
        System.out.println("=== FIN DEBUG ===");
        
        System.out.println("=== DEBUG SUPPLÉMENTAIRE ===");
        try {
            InputStream test5 = getClass().getClassLoader().getResourceAsStream("utility/app.conf");
            InputStream test6 = getClass().getClassLoader().getResourceAsStream("config/config.properties");
            InputStream test7 = getClass().getClassLoader().getResourceAsStream("database.properties");
            InputStream test8 = getClass().getClassLoader().getResourceAsStream("entity.properties");
            System.out.println("utility/app.conf trouvé: " + (test5 != null));
            System.out.println("config/config.properties trouvé: " + (test6 != null));
            System.out.println("database.properties trouvé: " + (test7 != null));
            System.out.println("entity.properties trouvé: " + (test8 != null));
            if(test5 != null) test5.close();
            if(test6 != null) test6.close();
            if(test7 != null) test7.close();
            if(test8 != null) test8.close();
        } catch(Exception debugE2) {
            debugE2.printStackTrace();
        }
        System.out.println("=== FIN DEBUG SUPPLÉMENTAIRE ===");
        
        // Context.initContext(); // COMMENTÉ TEMPORAIREMENT
        
        try{
            user = user.isValid();
            session.add("role",user.getRole());
            session.add("user",user.getId_users());
            if(user.getRole().equals("client")){
                Client cli = new Client();
                cli.setId_users(user.getId_users());
                Object[] obj = cli.find(null,cli,null,null,"");
                if(obj.length != 0){
                    cli = (Client)obj[0];
                    session.add("id_client",cli.getId_client());
                }
            }
        } catch(Exception e){
            e.printStackTrace();
            mv.addObject("errorMessage", "Wrong informations were provided.");
            mv.setViewUrl("login.jsp");
        }
        return mv;
    }

    @Url(url="/logout")
    public ModelView logout(MySession session) throws Exception{
        session.delete("role");
        session.delete("user");
        session.delete("id_client");
        ModelView mv = new ModelView("login.jsp");
        return mv;
    }
}