package br.ucsal.monitoria.apigateway.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/gateway")
public class HealthController {

    @Autowired
    private DiscoveryClient discoveryClient;

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", LocalDateTime.now());
        response.put("service", "API Gateway");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/services")
    public ResponseEntity<Map<String, Object>> getRegisteredServices() {
        List<String> services = discoveryClient.getServices();
        
        Map<String, Object> response = new HashMap<>();
        response.put("totalServices", services.size());
        response.put("services", services);
        response.put("timestamp", LocalDateTime.now());
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/routes")
    public ResponseEntity<Map<String, Object>> getRoutes() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Use /actuator/gateway/routes para ver todas as rotas");
        response.put("routes", List.of(
            "/auth-service/**",
            "/academic-service/**",
            "/student-service/**",
            "/monitoring-service/**",
            "/attendance-service/**",
            "/content-service/**",
            "/reporting-service/**"
        ));
        return ResponseEntity.ok(response);
    }
}
