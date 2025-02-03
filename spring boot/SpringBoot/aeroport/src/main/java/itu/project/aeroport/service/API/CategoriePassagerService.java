package itu.project.aeroport.service.API;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import itu.project.aeroport.model.reservation.CategoriePassager;

@Service
public class CategoriePassagerService {
    private final RestTemplate template;
    private final String baseUrl = "http://localhost:8080/aeroport";

    public CategoriePassagerService(RestTemplate rest){
        this.template = rest;
    }

    public CategoriePassager[] getList(){
        String url = baseUrl + "/categoriePassager";
        ResponseEntity<Map> informations = template.getForEntity(url,Map.class);
        List<Map<String,Object>> invoiceLineData = (List<Map<String,Object>>) informations.getBody().get("list");
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.convertValue(invoiceLineData, CategoriePassager[].class);

    }
}
