# 🚀 Certia V0 - Antigravity Kit

## 🏗️ Gerenciamento do Projeto

Para facilitar o uso, centralizamos os comandos comuns em um CLI dedicado:

👉 **[Leia o README_CLI.md](./README_CLI.md)** para o manual completo.

### Comandos Rápidos:
- `./certia.sh status` - Ver status da sessão.
- `./certia.sh prep <task> <project>` - Iniciar nova tarefa.
- `./certia.sh test` - Rodar testes.
- `./certia.sh lint-kit` - Validar integridade do kit.

## 📝 Exemplo de Prompt de Feature

Crie um endpoint no auth-x que retorne uma string com mensagem aleatoria positiva executando o workflow `/fluxo.md`. O nome da feature deve ser `feature-[RANDOM]`. Ajuste o endpoint `consume-hello` em `auth-y` para consumir desse novo endpoint.

## 🛠️ Uso do revision.sh

O arquivo `revision.sh` foi atualizado para receber parâmetros. Para executá-lo, utilize:

```bash
./revision.sh --feature "nome-da-feature"
```

## 🧜‍♀️ Serena (Indexação de Projeto)

O projeto utiliza o **Serena** para indexação automática de símbolos, fornecendo suporte avançado para recuperação de contexto por IA.

### Configuração
O Serena está configurado para:
- **Escopo**: Observar exclusivamente a pasta `projetos/`.
- **Exclusões**: Ignora `node_modules`, `dist`, `.venv`, `__pycache__`, etc.

### Como Executar
```bash
bash script/serena.sh
```

A configuração detalhada pode ser encontrada em `.serena/project.yml`.