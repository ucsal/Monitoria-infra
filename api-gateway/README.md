# API Gateway - Sistema de Monitorias UCSAL

**Gateway de API** do Sistema de Monitorias da UCSAL. Ponto único de entrada para todos os microserviços, responsável por roteamento, autenticação, balanceamento de carga e agregação de requisições.

## 🎯 O que é o API Gateway?

O API Gateway é a porta de entrada da arquitetura de microserviços, fornecendo:
- 🚪 **Ponto Único de Entrada**: Todos os clientes acessam uma única URL
- 🔐 **Autenticação Centralizada**: Valida JWT antes de rotear
- 🔄 **Roteamento Inteligente**: Direciona requisições para serviços corretos
- ⚖️ **Load Balancing**: Distribui carga entre instâncias
- 🛡️ **Rate Limiting**: Controle de taxa (futuro)
- 📊 **Monitoramento**: Logs e métricas centralizados

## 🚀 Tecnologias

- **Java 21**
- **Spring Boot 3.2.0**
- **Spring Cloud Gateway** (Reactive/WebFlux)
- **Spring Cloud Netflix Eureka Client**
- **Spring Cloud LoadBalancer**
- **JWT** para autenticação
- **Docker & Docker Compose**

## 📋 Funcionalidades

✅ Roteamento automático via Eureka  
✅ Autenticação JWT centralizada  
✅ Injeção de headers customizados  
✅ CORS configurado globalmente  
✅ Fallback para serviços indisponíveis  
✅ Health checks e métricas  
✅ Tratamento global de exceções  

## 🗺️ Arquitetura

```
┌───────────────────────────────────────────────────┐
│              CLIENT (Angular/React)               │
└───────────────────────┬───────────────────────────┘
                        │
                        │ HTTP Requests
                        ▼
┌───────────────────────────────────────────────────┐
│           API GATEWAY (Port 8080)                 │
│                                                   │
│  ┌─────────────────────────────────────────────┐ │
│  │  1. Valida JWT Token                        │ │
│  │  2. Extrai User Info                        │ │
│  │  3. Adiciona Headers (X-User-Id, X-Role)    │ │
│  │  4. Roteia para Serviço Correto             │ │
│  └─────────────────────────────────────────────┘ │
└───────────────────────┬───────────────────────────┘
                        │
                        │ Load Balanced Routing
         ┌──────────────┼──────────────┬──────────┐
         │              │              │          │
    ┌────▼────┐    ┌───▼────┐    ┌───▼────┐ ┌──▼──┐
    │  Auth   │    │Academic│    │Student │ │ ... │
    │ Service │    │Service │    │Service │ │     │
    └─────────┘    └────────┘    └────────┘ └─────┘
      :8081          :8082         :8083
```

## 🔧 Configuração

### Porta
- **8080** - Porta padrão do API Gateway

### Rotas Configuradas

| Rota | Serviço | Autenticação | Descrição |
|------|---------|--------------|-----------|
| `/auth-service/**` | Auth Service | ❌ Não | Login, registro, validação |
| `/academic-service/**` | Academic Service | ✅ Sim | Escolas, professores, disciplinas |
| `/student-service/**` | Student Service | ✅ Sim | Gestão de alunos |
| `/monitoring-service/**` | Monitoring Service | ✅ Sim | Monitorias |
| `/attendance-service/**` | Attendance Service | ✅ Sim | Frequência |
| `/content-service/**` | Content Service | ✅ Sim | Assuntos |
| `/reporting-service/**` | Reporting Service | ✅ Sim | Relatórios |

## 🔐 Fluxo de Autenticação

### 1. Requisição sem Autenticação (Público)

```
Client → Gateway → Auth Service
         (sem validação)
```

**Exemplo:**
```bash
POST http://localhost:8080/auth-service/api/auth/login
```

### 2. Requisição com Autenticação

```
Client → Gateway → [Valida JWT] → [Adiciona Headers] → Service
                        ↓
                   Auth Service
```

**Exemplo:**
```bash
GET http://localhost:8080/academic-service/api/admin/escolas
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Gateway adiciona headers:
# X-User-Id: 1
# X-Username: admin
# X-User-Role: ADMIN
# X-User-Email: admin@ucsal.br
# X-Professor-Id: 1
# X-Student-Id: 
```

## 🏃 Como Executar

### Pré-requisitos
1. **Eureka Server** rodando em `http://localhost:8761`
2. **Auth Service** rodando em `http://localhost:8081`

### Opção 1: Docker Compose (Recomendado)

```bash
# Criar rede (primeira vez)
docker network create monitoria-network

# Iniciar Gateway
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar
docker-compose down
```

### Opção 2: Execução Local

```bash
# Executar com Maven
mvn spring-boot:run

# Ou compilar e executar
mvn clean package
java -jar target/api-gateway-1.0.0.jar
```

## 📡 Endpoints do Gateway

### Health Check
```bash
GET http://localhost:8080/gateway/health
```

**Response:**
```json
{
  "status": "UP",
  "timestamp": "2024-01-15T10:30:00",
  "service": "API Gateway"
}
```

### Listar Serviços Registrados
```bash
GET http://localhost:8080/gateway/services
```

**Response:**
```json
{
  "totalServices": 3,
  "services": [
    "auth-service",
    "academic-service",
    "api-gateway"
  ],
  "timestamp": "2024-01-15T10:30:00"
}
```

### Listar Rotas
```bash
GET http://localhost:8080/gateway/routes
```

### Métricas do Gateway
```bash
GET http://localhost:8080/actuator/gateway/routes
```

## 🔍 Headers Customizados

O Gateway adiciona automaticamente estes headers para serviços downstream:

| Header | Descrição | Exemplo |
|--------|-----------|---------|
| `X-User-Id` | ID do usuário | `1` |
| `X-Username` | Nome de usuário | `admin` |
| `X-User-Role` | Role do usuário | `ADMIN` |
| `X-User-Email` | Email do usuário | `admin@ucsal.br` |
| `X-Professor-Id` | ID do professor | `1` |
| `X-Student-Id` | ID do aluno | `123` |

### Uso nos Serviços:

```java
@RestController
public class MyController {
    
    @GetMapping("/my-endpoint")
    public ResponseEntity<?> myEndpoint(
        @RequestHeader("X-User-Id") Long userId,
        @RequestHeader("X-User-Role") String role
    ) {
        // Usar informações do usuário
        return ResponseEntity.ok("User ID: " + userId);
    }
}
```

## 🌐 CORS

O Gateway tem CORS configurado globalmente:

```yaml
allowed-origins:
  - http://localhost:4200  # Angular
  - http://localhost:3000  # React

allowed-methods:
  - GET, POST, PUT, PATCH, DELETE, OPTIONS

allowed-headers:
  - * (todos)

allow-credentials: true
```

## 🚨 Tratamento de Erros

### Token Inválido ou Expirado
```json
{
  "error": "Unauthorized",
  "message": "Token expirado ou inválido",
  "status": 401
}
```

### Serviço Indisponível
```json
{
  "status": 503,
  "error": "Service Unavailable",
  "message": "Academic Service está temporariamente indisponível",
  "timestamp": "2024-01-15T10:30:00"
}
```

### Rota Não Encontrada
```json
{
  "status": 404,
  "error": "Not Found",
  "message": "Rota não encontrada",
  "path": "/invalid-route",
  "timestamp": "2024-01-15T10:30:00"
}
```

## 🧪 Testando o Gateway

### 1. Testar Rota Pública (Login)

```bash
curl -X POST http://localhost:8080/auth-service/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

### 2. Testar Rota Protegida

```bash
# Salvar token em variável
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Fazer requisição protegida
curl -X GET http://localhost:8080/academic-service/api/admin/escolas \
  -H "Authorization: Bearer $TOKEN"
```

### 3. Testar sem Token (Deve falhar)

```bash
curl -X GET http://localhost:8080/academic-service/api/admin/escolas
# Response: 401 Unauthorized
```

## 📊 Monitoramento

### Logs

```bash
# Ver logs em tempo real
docker-compose logs -f api-gateway

# Filtrar logs de autenticação
docker logs api-gateway 2>&1 | grep "Autenticando"

# Ver erros
docker logs api-gateway 2>&1 | grep "ERROR"
```

### Métricas Actuator

```bash
# Health
curl http://localhost:8080/actuator/health

# Métricas gerais
curl http://localhost:8080/actuator/metrics

# Rotas do Gateway
curl http://localhost:8080/actuator/gateway/routes

# Filtros aplicados
curl http://localhost:8080/actuator/gateway/globalfilters
```

## ⚡ Load Balancing

O Gateway usa **Spring Cloud LoadBalancer** para distribuir requisições:

```yaml
# Configuração automática via URI
uri: lb://auth-service  # "lb://" = Load Balanced

# Se houver 3 instâncias de auth-service:
# - auth-service-1:8081
# - auth-service-2:8081
# - auth-service-3:8081

# O Gateway distribui Round-Robin automaticamente
```

## 🔄 Circuit Breaker (Futuro)

Para adicionar Circuit Breaker com Resilience4j:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-circuitbreaker-reactor-resilience4j</artifactId>
</dependency>
```

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: auth-service
          uri: lb://auth-service
          predicates:
            - Path=/auth-service/**
          filters:
            - name: CircuitBreaker
              args:
                name: authServiceCircuitBreaker
                fallbackUri: forward:/fallback/auth-service
```

## 🐳 Docker Compose Completo

```yaml
version: '3.8'

services:
  eureka-server:
    image: eureka-server:1.0.0
    ports:
      - "8761:8761"
    networks:
      - monitoria-network

  auth-service:
    image: auth-service:1.0.0
    ports:
      - "8081:8081"
    environment:
      EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE: http://eureka-server:8761/eureka/
    depends_on:
      - eureka-server
    networks:
      - monitoria-network

  api-gateway:
    image: api-gateway:1.0.0
    ports:
      - "8080:8080"
    environment:
      EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE: http://eureka-server:8761/eureka/
      JWT_SECRET: your-secret-key
    depends_on:
      - eureka-server
      - auth-service
    networks:
      - monitoria-network

networks:
  monitoria-network:
    driver: bridge
```

## 🚨 Troubleshooting

### Gateway não encontra serviços

1. Verifique se o Eureka está rodando: `http://localhost:8761`
2. Confirme que os serviços estão registrados no Eureka
3. Verifique logs: `docker-compose logs api-gateway`

### Erro 401 em rotas protegidas

1. Verifique se o token JWT está válido
2. Confirme que o secret JWT é o mesmo do Auth Service
3. Teste o token em `/auth-service/api/auth/validate`

### CORS Errors

1. Verifique `allowed-origins` no `application.yml`
2. Adicione a origem do seu frontend
3. Certifique-se que `allow-credentials: true`

## 📄 Próximos Passos

Agora que temos Eureka + Gateway + Auth Service, podemos criar:

1. ✅ **Eureka Server** (Service Discovery)
2. ✅ **API Gateway** (Roteamento + Auth)
3. ✅ **Auth Service** (Autenticação)
4. ⬜ **Academic Service** (Escolas, Professores, Disciplinas)
5. ⬜ **Student Service** (Alunos)
6. ⬜ **Monitoring Service** (Monitorias)
7. ⬜ **Attendance Service** (Frequência)
8. ⬜ **Content Service** (Assuntos)
9. ⬜ **Reporting Service** (Relatórios)

## 📝 Licença

Este projeto faz parte do Sistema de Monitorias da UCSAL.

---

**Desenvolvido por**: Álvaro Dultra  
**Universidade**: UCSAL - Universidade Católica do Salvador  
**Curso**: Engenharia de Software - 6º Semestre
