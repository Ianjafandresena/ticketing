package itu.project.aeroport.service.API;

import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import itu.project.aeroport.component.LoggingRequestInterceptor;
import itu.project.aeroport.model.reservation.Reduction;

@Service
public class ReductionService {
    private final RestTemplate template;
    private final String baseUrl = "http://localhost:8080/aeroport";

    public ReductionService(RestTemplate template){
        this.template = template;
        this.template.getInterceptors().add(new LoggingRequestInterceptor());
    }

    public String insertReduction(Reduction reduction){
        String uri = baseUrl + "/insertAPIReduction";

        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Reduction> entity = new HttpEntity<>(reduction,header);

        ResponseEntity<Map> response = template.exchange(uri, HttpMethod.POST,entity,Map.class);

        return (String)response.getBody().get("message");
    }
}
