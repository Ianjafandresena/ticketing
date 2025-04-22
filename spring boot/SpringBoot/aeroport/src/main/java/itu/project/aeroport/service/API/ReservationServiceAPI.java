package itu.project.aeroport.service.API;

import java.util.List;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class ReservationServiceAPI {
    private final RestTemplate template;
    private final String baseUrl;

    public ReservationServiceAPI(RestTemplate template){
        this.template = template;
        baseUrl = "http://localhost:8080/aeroport";
    }

    public ResponseEntity<byte[]> export(String id,String type){
        String url = baseUrl + "/export?id="+id+"&type="+type;

        // Préparer la requête
        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(List.of(MediaType.ALL));

        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<byte[]> response = template.exchange(
                url,
                HttpMethod.GET,
                entity,
                byte[].class
        );

        // Vérifier que tout s’est bien passé
        if (response.getStatusCode().is2xxSuccessful()) {
            return ResponseEntity.ok()
                    .header("Content-Disposition","inline; filename=reservation_"+id+"."+type)
                    .contentType(response.getHeaders().getContentType())
                    .body(response.getBody());
        } else {
            throw new RuntimeException("Erreur lors du téléchargement : " + response.getStatusCode());
        }
    }
}
