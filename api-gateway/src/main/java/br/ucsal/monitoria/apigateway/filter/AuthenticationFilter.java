package br.ucsal.monitoria.apigateway.filter;

import br.ucsal.monitoria.apigateway.util.JwtUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
@Slf4j
public class AuthenticationFilter extends AbstractGatewayFilterFactory<AuthenticationFilter.Config> {

    @Autowired
    private JwtUtil jwtUtil;

    public AuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();

            log.info("Autenticando requisição: {} {}", request.getMethod(), request.getURI());

            // Verificar se o header Authorization existe
            if (!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                log.warn("Header Authorization ausente");
                return onError(exchange, "Header Authorization ausente", HttpStatus.UNAUTHORIZED);
            }

            String authHeader = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
            
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                log.warn("Token JWT inválido ou ausente");
                return onError(exchange, "Token JWT inválido", HttpStatus.UNAUTHORIZED);
            }

            String token = authHeader.substring(7);

            try {
                // Validar token
                if (!jwtUtil.validateToken(token)) {
                    log.warn("Token JWT expirado ou inválido");
                    return onError(exchange, "Token expirado ou inválido", HttpStatus.UNAUTHORIZED);
                }

                // Extrair informações do token
                String username = jwtUtil.extractUsername(token);
                String userId = jwtUtil.extractUserId(token);
                String role = jwtUtil.extractRole(token);
                String email = jwtUtil.extractEmail(token);
                Long professorId = jwtUtil.extractProfessorId(token);
                Long studentId = jwtUtil.extractStudentId(token);

                log.info("Token validado - User: {}, Role: {}", username, role);

                // Adicionar headers customizados para os serviços downstream
                ServerHttpRequest modifiedRequest = exchange.getRequest().mutate()
                        .header("X-User-Id", userId)
                        .header("X-Username", username)
                        .header("X-User-Role", role)
                        .header("X-User-Email", email)
                        .header("X-Professor-Id", professorId != null ? professorId.toString() : "")
                        .header("X-Student-Id", studentId != null ? studentId.toString() : "")
                        .build();

                return chain.filter(exchange.mutate().request(modifiedRequest).build());

            } catch (Exception e) {
                log.error("Erro ao validar token: {}", e.getMessage());
                return onError(exchange, "Erro na autenticação: " + e.getMessage(), HttpStatus.UNAUTHORIZED);
            }
        };
    }

    private Mono<Void> onError(ServerWebExchange exchange, String message, HttpStatus status) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(status);
        response.getHeaders().add("Content-Type", "application/json");
        
        String errorJson = String.format(
            "{\"error\":\"%s\",\"message\":\"%s\",\"status\":%d}",
            status.getReasonPhrase(),
            message,
            status.value()
        );
        
        return response.writeWith(
            Mono.just(response.bufferFactory().wrap(errorJson.getBytes()))
        );
    }

    public static class Config {
        // Configurações adicionais podem ser adicionadas aqui
    }
}
