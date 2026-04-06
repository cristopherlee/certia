# context-mode: Otimização de Janela de Contexto

Este documento resume as funcionalidades e a configuração do **context-mode** para agentes de IA (como o Antigravity), focado na redução drástica de consumo de tokens e melhoria de performance.

---

## 🧐 O que é o context-mode?

O **context-mode** é um servidor MCP (Model Context Protocol) projetado para otimizar o uso da janela de contexto. Ele atua como um "sandbox" para as saídas de ferramentas, impedindo que grandes volumes de dados (logs, HTML bruto, arquivos gigantes) "inundem" o contexto do chat.

### Principais Benefícios:
- **Redução de até 98%** no uso de contexto.
- **Sandboxing:** Executa comandos e processa arquivos sem trazer o conteúdo bruto para a conversa.
- **Indexação inteligente (FTS5):** Permite buscar informações específicas em grandes documentos sem ler o arquivo inteiro.
- **Suporte a 11 linguagens:** (JS, Python, Shell, etc.) para análise de dados local.

---

## 🚀 Instalação (Ubuntu + Antigravity)

A instalação no seu computador foi realizada seguindo este passo a passo:

### 1. Instalação Global do Pacote
Abra o seu terminal no Ubuntu e execute:
```bash
npm install -g context-mode
```

### 2. Configuração no Antigravity
Para que o Antigravity (Gemini) reconheça o servidor, ele deve ser adicionado ao arquivo de configuração global do MCP.

No seu sistema, o arquivo está localizado em:
`~/.gemini/antigravity/mcp_config.json`

**Dica:** Você também pode configurar por projeto no arquivo `.agent/mcp_config.json`.

### 3. Entrada de Configuração
Adicione o seguinte bloco dentro de `"mcpServers"`:
```json
"context-mode": {
    "command": "context-mode"
}
```

---

## 📂 Comandos e Ferramentas (Como usar)

O `context-mode` disponibiliza ferramentas que o Antigravity usa internamente, mas você pode me pedir para rodá-las usando os prefixos abaixo:

### Comandos de Utilidade (Status e Manutenção)
| Comando | Descrição |
| :--- | :--- |
| `ctx stats` | Mostra quanto contexto foi economizado, número de chamadas e estatísticas da sessão. |
| `ctx doctor` | Verifica se os runtimes (Python, Node) e o SQLite/FTS5 estão funcionando corretamente. |
| `ctx upgrade` | Atualiza o `context-mode` para a versão mais recente. |
| `ctx purge` | Limpa toda a base de conhecimento indexada (use para começar do zero). |

### Ferramentas de Processamento
- **`ctx_execute`**: Roda código (JS/Python/Shell) e traz apenas o resultado final (o `console.log`) para o chat.
- **`ctx_execute_file`**: Analisa um arquivo local sem ler o conteúdo todo. Útil para logs de gigabytes.
- **`ctx_fetch_and_index` / `ctx_search`**: Baixa URLs, converte para Markdown e permite buscar apenas as partes relevantes.
- **`ctx_batch_execute`**: O "Super Comando". Roda vários comandos de shell e faz buscas em todos os resultados em uma única chamada.

---

## 🛠️ Hierarquia de Ferramentas e Hooks no Antigravity

Diferente do Claude Code, o **Antigravity não possui suporte nativo para Hooks** (intercepção automática de chamadas). Por isso, o uso do `context-mode` é regido por regras de "roteamento manual" configuradas no arquivo `GEMINI.md`.

### Como o Antigravity utiliza o context-mode?

O agente (eu) segue uma hierarquia de decisão para garantir que o contexto não seja inundado:

1.  **GATHER (Coleta)**: Uso o `ctx_batch_execute` como ferramenta principal. Uma única chamada substitui 30+ individuais, rodando comandos e buscando resultados automaticamente.
2.  **FOLLOW-UP (Busca)**: Uso `ctx_search` para consultar o que já foi indexado na base de conhecimento (KIs).
3.  **PROCESSING (Processamento)**: Uso `ctx_execute` ou `ctx_execute_file` para analisar dados pesados. Só o resultado final (ex: "X testes falharam") entra no chat.
4.  **WEB (Busca Web)**: Uso `ctx_fetch_and_index` para ler documentações externas. O HTML bruto nunca entra no seu contexto.

### Perguntas Frequentes

*   **Isso roda automaticamente?**
    Não via hooks do sistema, mas **sim** através do meu comportamento programado no `GEMINI.md`. Eu sou instruído a preferir as ferramentas `ctx_` sempre que prevejo uma saída maior que 20 linhas.
*   **Eu preciso rodar essas ferramentas manualmente?**
    **Não.** Você pode simplesmente me pedir para "analisar o log" ou "buscar como configurar X". Eu decidirei qual ferramenta do `context-mode` é a mais adequada para economizar seu contexto e entregar a resposta mais rápida.


---

## 📊 Exemplo de Redução
| Cenário | Saída Bruta | No Contexto | Economia |
| :--- | :--- | :--- | :--- |
| Snapshot de Playwright | 56.2 KB | 299 B | **99%** |
| Log do Git (153 commits) | 11.6 KB | 107 B | **99%** |
| Documentação React | 5.9 KB | 261 B | **96%** |

Para ver como está o uso agora no seu sistema, peça: **"ctx stats"**.
