# Eureka Server - Sistema de Monitorias UCSAL

**Service Discovery Server** do Sistema de Monitorias da UCSAL. Responsável por registrar e descobrir todos os microserviços da arquitetura.

## 🎯 O que é o Eureka Server?

O Eureka é um serviço de **Service Discovery** da Netflix que permite:
- 📋 **Registro de serviços**: Microserviços se auto-registram automaticamente
- 🔍 **Descoberta de serviços**: Permite que serviços encontrem uns aos outros
- 💓 **Health checks**: Monitora a saúde dos serviços registrados
- ⚖️ **Load balancing**: Distribui requisições entre instâncias

## 🚀 Tecnologias

- **Java 21**
- **Spring Boot 3.2.0**
- **Spring Cloud Netflix Eureka Server 2023.0.0**
- **Docker & Docker Compose**

## 📋 Funcionalidades

✅ Registro automático de microserviços  
✅ Dashboard visual para monitoramento  
✅ Health checks de serviços  
✅ Renovação automática de registros  
✅ Remoção de serviços inativos  
✅ Suporte a múltiplas instâncias  

## 🗺️ Arquitetura

```
┌─────────────────────────────────────────────────┐
│           EUREKA SERVER (8761)                  │
│                                                 │
│  ┌─────────────────────────────────────────┐  │
│  │     Service Registry Dashboard          │  │
│  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                     ▲
                     │ Register & Heartbeat
         ┌───────────┼───────────┬───────────┐
         │           │           │           │
    ┌────▼────┐ ┌───▼────┐ ┌───▼────┐ ┌───▼────┐
    │  Auth   │ │Academic│ │Student │ │Gateway │
    │ Service │ │Service │ │Service │ │        │
    └─────────┘ └────────┘ └────────┘ └────────┘
      :8081       :8082      :8083      :8080
```

## 🔧 Configuração

### Porta
- **8761** - Porta padrão do Eureka Server

### Configurações Principais

```yaml
eureka:
  client:
    register-with-eureka: false  # Não se auto-registrar
    fetch-registry: false        # Não buscar registro
  server:
    enable-self-preservation: false  # Desabilitar em dev
    eviction-interval-timer-in-ms: 5000  # Remover serviços inativos
```

## 🏃 Como Executar

### Opção 1: Docker Compose (Recomendado)

```bash
# Criar rede (primeira vez apenas)
docker network create monitoria-network

# Iniciar Eureka Server
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar serviço
docker-compose down
```

### Opção 2: Execução Local

```bash
# Executar com Maven
mvn spring-boot:run

# Ou compilar e executar
mvn clean package
java -jar target/eureka-server-1.0.0.jar
```

### Opção 3: Build Docker Manual

```bash
# Build da imagem
docker build -t eureka-server:1.0.0 .

# Executar container
docker run -d \
  --name eureka-server \
  --network monitoria-network \
  -p 8761:8761 \
  eureka-server:1.0.0
```

## 📊 Dashboard

Acesse o dashboard do Eureka em:

```
http://localhost:8761
```

### O que você verá no Dashboard:

1. **System Status**: Status geral do servidor
2. **DS Replicas**: Réplicas do servidor (vazio em single instance)
3. **Instances currently registered with Eureka**: Lista de serviços registrados
4. **General Info**: Informações gerais do ambiente
5. **Instance Info**: Detalhes de cada instância registrada

### Exemplo de Dashboard:

```
┌─────────────────────────────────────────────────────┐
│  EUREKA                                             │
│                                                     │
│  Instances currently registered with Eureka        │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │ AUTH-SERVICE                                  │ │
│  │   • Instance: auth-service:8081               │ │
│  │   • Status: UP                                │ │
│  │   • Uptime: 2h 15m                           │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  ┌───────────────────────────────────────────────┐ │
│  │ ACADEMIC-SERVICE                              │ │
│  │   • Instance: academic-service:8082           │ │
│  │   • Status: UP                                │ │
│  │   • Uptime: 1h 42m                           │ │
│  └───────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

## 🔌 Como os Serviços se Registram

### 1. Adicionar Dependência no Serviço

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

### 2. Configurar application.yml do Serviço

```yaml
spring:
  application:
    name: auth-service  # Nome do serviço

eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
    register-with-eureka: true
    fetch-registry: true
  instance:
    prefer-ip-address: true
    instance-id: ${spring.application.name}:${server.port}
```

### 3. Adicionar Anotação na Classe Principal

```java
@SpringBootApplication
@EnableDiscoveryClient  // Habilita cliente Eureka
public class AuthServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(AuthServiceApplication.class, args);
    }
}
```

## 💓 Health Checks

O Eureka envia heartbeats para verificar se os serviços estão ativos:

- **Intervalo de Renovação**: 30 segundos (padrão)
- **Timeout de Lease**: 90 segundos (padrão)
- **Intervalo de Remoção**: 5 segundos (configurado)

Se um serviço não enviar heartbeat por 90 segundos, é removido do registro.

## 📡 Endpoints

### Dashboard
```
GET http://localhost:8761
```

### API REST do Eureka

#### Listar Todos os Serviços Registrados
```bash
curl http://localhost:8761/eureka/apps
```

#### Listar Instâncias de um Serviço Específico
```bash
curl http://localhost:8761/eureka/apps/AUTH-SERVICE
```

#### Health Check
```bash
curl http://localhost:8761/actuator/health
```

#### Métricas
```bash
curl http://localhost:8761/actuator/metrics
```

## 🔍 Descoberta de Serviços

### Como usar em outros serviços:

```java
@Service
@RequiredArgsConstructor
public class SomeService {
    
    private final DiscoveryClient discoveryClient;
    
    public List<ServiceInstance> getAuthServiceInstances() {
        return discoveryClient.getInstances("AUTH-SERVICE");
    }
    
    public String getAuthServiceUrl() {
        List<ServiceInstance> instances = discoveryClient.getInstances("AUTH-SERVICE");
        if (!instances.isEmpty()) {
            ServiceInstance instance = instances.get(0);
            return instance.getUri().toString();
        }
        throw new RuntimeException("Auth Service não disponível");
    }
}
```

### Com Feign Client (Comunicação REST):

```java
@FeignClient(name = "auth-service")
public interface AuthServiceClient {
    
    @PostMapping("/api/auth/validate")
    TokenValidationResponse validateToken(@RequestHeader("Authorization") String token);
}
```

## 🐳 Docker

### Configuração Docker Compose Completo

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

  academic-service:
    image: academic-service:1.0.0
    ports:
      - "8082:8082"
    environment:
      EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE: http://eureka-server:8761/eureka/
    depends_on:
      - eureka-server
    networks:
      - monitoria-network

networks:
  monitoria-network:
    driver: bridge
```

## 🔒 Segurança

### Em Produção, adicione autenticação:

```yaml
spring:
  security:
    user:
      name: admin
      password: ${EUREKA_PASSWORD}
```

### Configure os clientes:

```yaml
eureka:
  client:
    service-url:
      defaultZone: http://admin:${EUREKA_PASSWORD}@eureka-server:8761/eureka/
```

## 🚨 Troubleshooting

### Serviço não aparece no Dashboard

1. Verifique se o serviço está rodando
2. Confirme a configuração do `eureka.client.service-url.defaultZone`
3. Verifique os logs do serviço
4. Certifique-se que `@EnableDiscoveryClient` está presente

### Serviço aparece como DOWN

1. Verifique o health check do serviço: `/actuator/health`
2. Confirme que o serviço está acessível
3. Verifique firewall/network

### Serviço é removido frequentemente

1. Aumente o `eureka.instance.lease-renewal-interval-in-seconds`
2. Aumente o `eureka.instance.lease-expiration-duration-in-seconds`
3. Verifique latência de rede

## 📈 Monitoramento

### Métricas Importantes

```bash
# Número de serviços registrados
curl http://localhost:8761/actuator/metrics/eureka.server.registry.count

# Renovações por minuto
curl http://localhost:8761/actuator/metrics/eureka.server.renewals
```

## 🎯 Próximos Passos

Após iniciar o Eureka Server, os próximos serviços a configurar são:

1. ✅ **Eureka Server** (atual)
2. ⬜ **API Gateway** - Roteamento e autenticação
3. ⬜ **Config Server** - Configuração centralizada (opcional)
4. ⬜ Demais microserviços (Auth, Academic, Student, etc.)

## 📝 Ordem de Inicialização

```
1. Eureka Server      (8761)
2. Config Server      (8888) - opcional
3. Auth Service       (8081)
4. Academic Service   (8082)
5. Student Service    (8083)
6. Monitoring Service (8084)
7. Attendance Service (8085)
8. Content Service    (8086)
9. Reporting Service  (8087)
10. API Gateway       (8080) - último!
```

## 📄 Licença

Este projeto faz parte do Sistema de Monitorias da UCSAL.

---

**Desenvolvido por**: Álvaro Dultra  
**Universidade**: UCSAL - Universidade Católica do Salvador  
**Curso**: Engenharia de Software - 6º Semestre
