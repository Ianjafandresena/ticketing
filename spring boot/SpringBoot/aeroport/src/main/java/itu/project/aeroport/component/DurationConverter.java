package itu.project.aeroport.component;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Component
public class DurationConverter implements Converter<String,Duration>{
    @Override
    public Duration convert(String source) {
        if(source.equals("") || source == null) return null;
        String[] parts = source.split(":");
        return  Duration.ofHours(Integer.parseInt(parts[0])).plusMinutes(Integer.parseInt(parts[1])).plusSeconds(Integer.parseInt(parts[3]));
    }
}
