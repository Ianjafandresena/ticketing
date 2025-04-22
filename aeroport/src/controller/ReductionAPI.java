package controller;

import aeroport.vol.Reduction;
import mg.itu.annotation.ControlleurAnnotation;
import mg.itu.annotation.Post;
import mg.itu.annotation.RequestBody;
import mg.itu.annotation.RestAPI;
import mg.itu.annotation.Url;
import mg.itu.utils.ModelView;

@ControlleurAnnotation(url="/api/reduction")
public class ReductionAPI {
    @RestAPI
    @Post
    @Url(url="/insertAPIReduction")
    public ModelView insert(@RequestBody(name="reduction") Reduction reduction){
        String message = "Reduction configurée avec succès";
        try{
            reduction.insert();
        }catch(Exception e){
            e.printStackTrace();
            message = "Une erreur s'est produite";
        }
        ModelView model = new ModelView();
        model.addObject("message", message);

        return model;
    }
}
