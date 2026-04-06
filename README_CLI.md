# 🛠️ Certia CLI - Centralizador de Comandos

O **Certia CLI** (`certia.sh`) e o **Makefile** centralizam as operações mais comuns do projeto, abstraindo caminhos complexos e scripts internos.

---

## 🚀 Como Usar

Você pode usar tanto o script shell quanto o Makefile:

```bash
# Via Script Shell
./certia.sh <comando> [argumentos]

# Via Makefile
make <comando> [parâmetros]
```

---

## 📋 Comandos Disponíveis

| Comando | Descrição | Exemplo |
| :--- | :--- | :--- |
| **`prep`** | Prepara o ambiente para uma nova tarefa. | `./certia.sh prep my-task project-a` ou `make prep task=my-task project=project-a` |
| **`test`** | Executa a suíte de testes (Test Runner). | `./certia.sh test .` ou `make test` |
| **`verify`** | Verificação completa (Security, UX, E2E, etc.). | `./certia.sh verify http://url` ou `make verify url=http://url` |
| **`status`** | Mostra o status atual da sessão e do projeto. | `./certia.sh status` ou `make status` |
| **`clean`** | Gerenciamento de tarefas (list, archive, remove). | `./certia.sh clean list` ou `make clean cmd=list` |
| **`clone`** | Clona um repositório legado do projeto. | `./certia.sh clone <repo> <destino>` |
| **`lint-kit`** | Valida o catálogo de agentes e o schema de projetos. | `./certia.sh lint-kit` |
| **`manage-kit`** | Abre o menu interativo de integridade do kit. | `./certia.sh manage-kit` ou `./manage_kit.sh` |
| **`help`** | Mostra o menu de ajuda detalhado. | `./certia.sh help` |

---

## 🏗️ Estrutura Interna Mapeada

O CLI centraliza chamadas para os seguintes locais:

- **Preparação:** `scripts/preparatorio.sh` e `.agent/scripts/prepare_task.sh`
- **Testes:** `.agent/skills/testing-patterns/scripts/test_runner.py`
- **Verificação:** `.agent/scripts/verify_all.py`
- **Status:** `.agent/scripts/session_manager.py` e `auto_preview.py`
- **Limpeza:** `scripts/cleanup.sh`
- **Validação Kit:** `.agent/scripts/verify_catalog.py` e `verify_projects.py`

---

## 💡 Dicas

- Certifique-se de que o script `certia.sh` tenha permissão de execução: `chmod +x certia.sh`.
- Use o Makefile para comandos rápidos que não exigem scripts externos complexos.
- Para adicionar novos comandos, edite o arquivo `certia.sh` na raiz.
