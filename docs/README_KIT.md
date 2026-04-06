# Gerenciador de Integridade do Antigravity Kit

Este repositório inclui ferramentas para garantir a consistência dos agentes e projetos cadastrados.

## Comandos Rápidos

O script principal centraliza essas validações através de um menu interativo:

```bash
# Via menu interativo
./manage_kit.sh

# Ou via CLI central
./certia.sh manage-kit
```

### Ferramentas Disponíveis

| Ferramenta | Descrição | Script Destino |
|:---|:---|:---|
| **Lint de Agentes** | Garante que todos os agentes em `AGENT_CATALOG.md` existam fisicamente em `.agent/agents/` e vice-versa. | `.agent/scripts/verify_catalog.py` |
| **Validação de Projetos** | Valida o arquivo `projects.json` (global ou local) contra o `projects.schema.json`. | `.agent/scripts/verify_projects.py` |
| **JSON Schema** | Define a estrutura obrigatória para o cadastro de projetos. | `.agent/schemas/projects.schema.json` |

## Como usar as validações em scripts/CI

Se você deseja rodar as validações sem o menu interativo:

### 1. Validar Catálogo de Agentes
```bash
python3 .agent/scripts/verify_catalog.py
```

### 2. Validar Estrutura de Projetos
```bash
python3 .agent/scripts/verify_projects.py
```

---
> [!TIP]
> Use estas ferramentas antes de iniciar qualquer nova tarefa no workflow `preparatorio.md` para evitar erros de "Projeto não encontrado" ou "Agente ausente".
