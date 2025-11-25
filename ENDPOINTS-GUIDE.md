# Guia de Endpoints - Sistema de Monitorias UCSAL

## Status: Todos os endpoints estão funcionando! ✅

Após a correção das configurações, todos os endpoints estão respondendo corretamente tanto via acesso direto quanto via API Gateway.

## Configurações Implementadas

### Mudanças Realizadas
- ✅ Removido `context-path` de todos os microserviços
- ✅ API Gateway configurado com `StripPrefix=1`
- ✅ Containers rebuilded com novas configurações
- ✅ Todos os endpoints testados e funcionando
- ✅ **Implementado endpoints DELETE para Escolas, Professores, Disciplinas e Alunos**

## URLs de Acesso

### Acesso Direto aos Serviços (sem API Gateway)

#### Auth Service (Port 8081)
```bash
curl http://localhost:8081/api/auth/register
curl http://localhost:8081/api/auth/login
curl http://localhost:8081/api/auth/logout
curl http://localhost:8081/api/auth/refresh
curl http://localhost:8081/api/auth/validate
```

#### Academic Service (Port 8082)
```bash
# Escolas
curl http://localhost:8082/api/admin/escolas
curl http://localhost:8082/api/admin/escolas/ativas
curl http://localhost:8082/api/admin/escolas/{id}

# Professores
curl http://localhost:8082/api/admin/professores
curl http://localhost:8082/api/admin/professores/ativos
curl http://localhost:8082/api/admin/professores/{id}

# Disciplinas
curl http://localhost:8082/api/admin/disciplinas
curl http://localhost:8082/api/admin/disciplinas/ativas
curl http://localhost:8082/api/admin/disciplinas/{id}
```

#### Student Service (Port 8083)
```bash
curl http://localhost:8083/api/professor/alunos
curl http://localhost:8083/api/professor/alunos/ativos
curl http://localhost:8083/api/professor/alunos/{id}
```

#### Monitoring Service (Port 8084)
```bash
curl http://localhost:8084/api/professor/monitorias
curl http://localhost:8084/api/professor/monitorias/em-andamento
curl http://localhost:8084/api/professor/monitorias/professor/{id}
curl http://localhost:8084/api/professor/monitorias/{id}
```

### Acesso via API Gateway (Port 8080) - RECOMENDADO

#### Auth Service
```bash
curl http://localhost:8080/auth-service/api/auth/register
curl http://localhost:8080/auth-service/api/auth/login
curl http://localhost:8080/auth-service/api/auth/logout
curl http://localhost:8080/auth-service/api/auth/refresh
curl http://localhost:8080/auth-service/api/auth/validate
```

#### Academic Service
```bash
# Escolas
curl http://localhost:8080/academic-service/api/admin/escolas
curl http://localhost:8080/academic-service/api/admin/escolas/ativas
curl http://localhost:8080/academic-service/api/admin/escolas/{id}

# Professores
curl http://localhost:8080/academic-service/api/admin/professores
curl http://localhost:8080/academic-service/api/admin/professores/ativos
curl http://localhost:8080/academic-service/api/admin/professores/{id}

# Disciplinas
curl http://localhost:8080/academic-service/api/admin/disciplinas
curl http://localhost:8080/academic-service/api/admin/disciplinas/ativas
curl http://localhost:8080/academic-service/api/admin/disciplinas/{id}
```

#### Student Service
```bash
curl http://localhost:8080/student-service/api/professor/alunos
curl http://localhost:8080/student-service/api/professor/alunos/ativos
curl http://localhost:8080/student-service/api/professor/alunos/{id}
```

#### Monitoring Service
```bash
curl http://localhost:8080/monitoring-service/api/professor/monitorias
curl http://localhost:8080/monitoring-service/api/professor/monitorias/em-andamento
curl http://localhost:8080/monitoring-service/api/professor/monitorias/professor/{id}
curl http://localhost:8080/monitoring-service/api/professor/monitorias/{id}
```

## Lista Completa de Endpoints Implementados

### 🔐 Auth Service
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/auth/register` | Registrar novo usuário |
| POST | `/api/auth/login` | Login de usuário |
| POST | `/api/auth/logout` | Logout de usuário |
| POST | `/api/auth/refresh` | Refresh token |
| POST | `/api/auth/validate` | Validar token |

### 🏫 Academic Service - Escolas
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/admin/escolas` | Listar todas as escolas |
| GET | `/api/admin/escolas/ativas` | Listar escolas ativas |
| GET | `/api/admin/escolas/{id}` | Buscar escola por ID |
| POST | `/api/admin/escolas` | Criar nova escola |
| PUT | `/api/admin/escolas/{id}` | Atualizar escola |
| PATCH | `/api/admin/escolas/{id}/inativar` | Inativar escola |
| PATCH | `/api/admin/escolas/{id}/ativar` | Ativar escola |
| **DELETE** | **`/api/admin/escolas/{id}`** | **Deletar escola** |

### 👨‍🏫 Academic Service - Professores
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/admin/professores` | Listar todos os professores |
| GET | `/api/admin/professores/ativos` | Listar professores ativos |
| GET | `/api/admin/professores/{id}` | Buscar professor por ID |
| POST | `/api/admin/professores` | Criar novo professor |
| PUT | `/api/admin/professores/{id}` | Atualizar professor |
| PATCH | `/api/admin/professores/{id}/inativar` | Inativar professor |
| PATCH | `/api/admin/professores/{id}/ativar` | Ativar professor |
| **DELETE** | **`/api/admin/professores/{id}`** | **Deletar professor** |

### 📚 Academic Service - Disciplinas
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/admin/disciplinas` | Listar todas as disciplinas |
| GET | `/api/admin/disciplinas/ativas` | Listar disciplinas ativas |
| GET | `/api/admin/disciplinas/{id}` | Buscar disciplina por ID |
| POST | `/api/admin/disciplinas` | Criar nova disciplina |
| PUT | `/api/admin/disciplinas/{id}` | Atualizar disciplina |
| PATCH | `/api/admin/disciplinas/{id}/inativar` | Inativar disciplina |
| PATCH | `/api/admin/disciplinas/{id}/ativar` | Ativar disciplina |
| **DELETE** | **`/api/admin/disciplinas/{id}`** | **Deletar disciplina** |

### 👨‍🎓 Student Service - Alunos
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/professor/alunos` | Listar todos os alunos |
| GET | `/api/professor/alunos/ativos` | Listar alunos ativos |
| GET | `/api/professor/alunos/{id}` | Buscar aluno por ID |
| POST | `/api/professor/alunos` | Criar novo aluno |
| PUT | `/api/professor/alunos/{id}` | Atualizar aluno |
| PATCH | `/api/professor/alunos/{id}/inativar` | Inativar aluno |
| PATCH | `/api/professor/alunos/{id}/ativar` | Ativar aluno |
| **DELETE** | **`/api/professor/alunos/{id}`** | **Deletar aluno** |

### 📊 Monitoring Service - Monitorias
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/professor/monitorias` | Listar todas as monitorias |
| GET | `/api/professor/monitorias/em-andamento` | Listar monitorias em andamento |
| GET | `/api/professor/monitorias/professor/{id}` | Listar monitorias por professor |
| GET | `/api/professor/monitorias/{id}` | Buscar monitoria por ID |
| GET | `/api/professor/monitorias/{id}/quantidade-alunos` | Quantidade de alunos na monitoria |
| POST | `/api/professor/monitorias` | Criar nova monitoria |
| POST | `/api/professor/monitorias/associar-aluno` | Associar aluno à monitoria |
| PUT | `/api/professor/monitorias/{id}` | Atualizar monitoria |
| PATCH | `/api/professor/monitorias/{id}/iniciar` | Iniciar monitoria |
| PATCH | `/api/professor/monitorias/{id}/finalizar` | Finalizar monitoria |
| PATCH | `/api/professor/monitorias/{id}/cancelar` | Cancelar monitoria |
| DELETE | `/api/professor/monitor/{id}` | Remover aluno da monitoria |

## Como Testar

### Teste de Registro (Auth Service)
```bash
curl -X POST http://localhost:8080/auth-service/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "email": "admin@ucsal.br",
    "fullName": "Administrador Sistema",
    "role": "ADMIN"
  }'
```

### Teste de Login
```bash
curl -X POST http://localhost:8080/auth-service/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

### Teste de Listagem (GET)
```bash
# Listar escolas
curl http://localhost:8080/academic-service/api/admin/escolas

# Listar alunos
curl http://localhost:8080/student-service/api/professor/alunos

# Listar monitorias
curl http://localhost:8080/monitoring-service/api/professor/monitorias
```

## Comandos Docker

### Reiniciar todos os serviços
```bash
docker-compose -f docker-compose-complete.yml down
docker-compose -f docker-compose-complete.yml up -d --build
```

### Ver logs dos serviços
```bash
docker-compose -f docker-compose-complete.yml logs -f
```

### Ver status dos containers
```bash
docker ps
```

## Observações Importantes

1. **Prefixo do Gateway**: Ao acessar via API Gateway (porta 8080), sempre inclua o nome do serviço no path (ex: `/auth-service/`, `/academic-service/`, etc.)

2. **Acesso Direto**: Ao acessar os serviços diretamente pelas suas portas (8081-8084), NÃO inclua o prefixo do serviço

3. **Autenticação**: Endpoints protegidos requerem token JWT no header `Authorization: Bearer <token>`

4. **CORS**: O API Gateway está configurado para aceitar requisições das origens:
   - http://localhost:4200 (Angular)
   - http://localhost:3000 (React)
   - http://localhost:5173 (Vite)

5. **Validação**: Todos os endpoints validam os dados de entrada. Certifique-se de enviar todos os campos obrigatórios

## Resolução de Problemas

### Serviço não responde
```bash
# Verificar se o container está rodando
docker ps | grep <service-name>

# Ver logs do serviço
docker logs <container-name>
```

### Erro 404
- Verifique se está usando o prefixo correto (`/auth-service/`, `/academic-service/`, etc.)
- Confirme se o serviço está registrado no Eureka: http://localhost:8761

### Erro 500
- Verifique os logs do serviço específico
- Confirme se o banco de dados está acessível
- Verifique se todos os campos obrigatórios foram enviados

## Portas dos Serviços

| Serviço | Porta | URL |
|---------|-------|-----|
| API Gateway | 8080 | http://localhost:8080 |
| Eureka Server | 8761 | http://localhost:8761 |
| Auth Service | 8081 | http://localhost:8081 |
| Academic Service | 8082 | http://localhost:8082 |
| Student Service | 8083 | http://localhost:8083 |
| Monitoring Service | 8084 | http://localhost:8084 |
| Attendance Service | 8085 | http://localhost:8085 |
| Content Service | 8086 | http://localhost:8086 |

## Frontend Configuration

Configure o frontend para usar o API Gateway:
```typescript
const API_BASE_URL = 'http://localhost:8080';

// Auth endpoints
const AUTH_API = `${API_BASE_URL}/auth-service/api/auth`;

// Academic endpoints
const ACADEMIC_API = `${API_BASE_URL}/academic-service/api/admin`;

// Student endpoints
const STUDENT_API = `${API_BASE_URL}/student-service/api/professor`;

// Monitoring endpoints
const MONITORING_API = `${API_BASE_URL}/monitoring-service/api/professor`;
```
