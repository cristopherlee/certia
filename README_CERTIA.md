# 🚀 Certia CLI - Manual do Usuário

O **Certia CLI** (`certia.sh`) é a interface de comando central que organiza e simplifica o fluxo de trabalho no ecossistema Antigravity Kit. Ele abstrai a complexidade operacional, permitindo que você foque na execução das tarefas.

---

## 📂 Nova Estrutura de Documentação e Scripts

Para manter a organização, os arquivos foram movidos para locais específicos:
- `docs/README_CLI.md`: Detalhes técnicos da CLI original.
- `docs/README_KIT.md`: Manual de integridade dos agentes e projetos.
- `scripts/Makefile`: Atalhos de comando (via `make`).
- `scripts/manage_kit.sh`: Menu interativo de integridade.
- `completed_tasks/`: Pasta para armazenamento de tarefas finalizadas (antigo `archives`).

---

## 🛠️ Como Usar o `certia.sh`

O script está localizado na raiz do projeto e pode ser executado diretamente:

```bash
./certia.sh <comando> [argumentos...]
```

### 📋 Comandos e Exemplos

| Comando | Descrição | Exemplo de Uso |
| :--- | :--- | :--- |
| **`prep`** | Prepara o ambiente isolado para uma nova tarefa. | `./certia.sh prep fix-login portal-x` |
| **`test`** | Executa a suíte de testes no projeto atual. | `./certia.sh test .` |
| **`verify`** | Auditoria completa (Segurança, UX, SEO, E2E). | `./certia.sh verify http://meu-app.local` |
| **`status`** | Exibe o status da sessão, tokens e preview. | `./certia.sh status` |
| **`clean`** | Gerencia tarefas (list, archive, remove). | `./certia.sh clean archive fix-login` |
| **`clear-completed`** | Apaga todos os arquivos em `completed_tasks/`. | `./certia.sh clear-completed` |
| **`lint-kit`** | Valida a integridade do catálogo e projetos. | `./certia.sh lint-kit` |
| **`manage-kit`** | Abre o menu interativo de gestão do kit. | `./certia.sh manage-kit` |
| **`clone`** | Utilitário para clonagem de repositórios. | `./certia.sh clone repo-url destino` |

---

## ⚡ Fluxos Comuns

### 1. Iniciando uma Nova Tarefa
O fluxo recomendado começa sempre pela preparação:
```bash
# 1. Valide o kit antes de começar
./certia.sh lint-kit

# 2. Crie o ambiente da tarefa
./certia.sh prep minha-nova-funcionalidade nome-do-projeto
```

### 2. Finalizando e Limpando
Após concluir uma tarefa e validar com `verify`, você pode arquivá-la:
```bash
# Arquiva em completed_tasks/ e remove de tasks/
./certia.sh clean archive minha-nova-funcionalidade

# Limpa o histórico de tarefas concluídas (Cuidado!)
./certia.sh clear-completed
```

---

## 💡 Dicas de Produtividade
- O script `certia.sh` deve ter permissão de execução: `chmod +x certia.sh`.
- Se preferir usar o Makefile, note que agora ele reside em `scripts/`. Você pode usá-lo via:
  ```bash
  cd scripts && make prep task=xxx project=yyy
  ```

---
> **Nota:** Para detalhes sobre a arquitetura interna e mapeamento de scripts, consulte [docs/README_CLI.md](docs/README_CLI.md).
