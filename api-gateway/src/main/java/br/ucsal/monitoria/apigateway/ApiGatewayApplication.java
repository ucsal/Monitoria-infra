package br.ucsal.monitoria.apigateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("🚪 API Gateway iniciado com sucesso!");
        System.out.println("🌐 Endereço: http://localhost:8080");
        System.out.println("========================================\n");
    }
}
