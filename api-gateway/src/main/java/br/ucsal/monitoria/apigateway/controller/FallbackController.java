package br.ucsal.monitoria.apigateway.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
public class FallbackController {

    @GetMapping("/fallback/auth-service")
    public ResponseEntity<Map<String, Object>> authServiceFallback() {
        return buildFallbackResponse("Auth Service está temporariamente indisponível");
    }

    @GetMapping("/fallback/academic-service")
    public ResponseEntity<Map<String, Object>> academicServiceFallback() {
        return buildFallbackResponse("Academic Service está temporariamente indisponível");
    }

    @GetMapping("/fallback/student-service")
    public ResponseEntity<Map<String, Object>> studentServiceFallback() {
        return buildFallbackResponse("Student Service está temporariamente indisponível");
    }

    @GetMapping("/fallback/monitoring-service")
    public ResponseEntity<Map<String, Object>> monitoringServiceFallback() {
        return buildFallbackResponse("Monitoring Service está temporariamente indisponível");
    }

    @GetMapping("/fallback/attendance-service")
    public ResponseEntity<Map<String, Object>> attendanceServiceFallback() {
        return buildFallbackResponse("Attendance Service está temporariamente indisponível");
    }

    @GetMapping("/fallback/content-service")
    public ResponseEntity<Map<String, Object>> contentServiceFallback() {
        return buildFallbackResponse("Content Service está temporariamente indisponível");
    }

    @GetMapping("/fallback/reporting-service")
    public ResponseEntity<Map<String, Object>> reportingServiceFallback() {
        return buildFallbackResponse("Reporting Service está temporariamente indisponível");
    }

    private ResponseEntity<Map<String, Object>> buildFallbackResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("status", HttpStatus.SERVICE_UNAVAILABLE.value());
        response.put("error", "Service Unavailable");
        response.put("message", message);
        response.put("timestamp", LocalDateTime.now());
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
}
