package itu.project.aeroport.component;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import java.time.Duration;
import java.time.format.DateTimeParseException;

@Converter(autoApply = true)
public class DurationAttributeConverter implements AttributeConverter<Duration, String> {

    @Override
    public String convertToDatabaseColumn(Duration duration) {
        // Convertit Duration en String ISO-8601 (ex: PT7H30M)
        return (duration == null) ? null : duration.toString();
    }

    @Override
    public Duration convertToEntityAttribute(String dbData) {
       if (dbData == null || dbData.trim().isEmpty()) {
        return null;
    }
    try {
        String[] parts = dbData.split(":");
        if(parts.length < 2) {
            throw new IllegalArgumentException("Format de durée invalide : " + dbData);
        }
        int hours = Integer.parseInt(parts[0]);
        int minutes = Integer.parseInt(parts[1]);
        int seconds = (parts.length > 2) ? Integer.parseInt(parts[2]) : 0;
        return Duration.ofHours(hours).plusMinutes(minutes).plusSeconds(seconds);
    } catch (Exception e) {
        throw new IllegalArgumentException("Impossible de parser la durée : " + dbData, e);
    }
    }
}

