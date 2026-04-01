README Serena — Uso rápido
=========================

Resumo rápido de comandos para indexar pastas com Serena e iniciar o MCP server.

1) Indexar somente uma pasta (script helper)

  - Uso (executar na raiz do repositório):

    ./serena.sh features/<nome-da-sessao>

  - O `serena.sh` aceita caminho relativo ou absoluto. Ele entra na pasta alvo e executa `serena project index` apenas nessa pasta.
  - Se não houver um projeto Serena na pasta, o comando tenta criar automaticamente `.serena/project.yml`.
  - Se a pasta não contiver arquivos de código suportados, Serena criará o projeto mas poderá indexar 0 arquivos (ferramentas de símbolo ficarão limitadas).

    - Além disso, `serena.sh` agora verifica se o MCP do Serena está em execução (porta `9121` ou processo `serena start-mcp-server`).
      - Se não encontrar o servidor, o script tentará iniciá-lo em background usando:

        uvx --from git+https://github.com/oraios/serena serena start-mcp-server --transport streamable-http --port 9121

      - Saída e logs do servidor são gravados em `/tmp/serena_mcp.log`.
      - O script aguardará brevemente para confirmar que o servidor subiu; se não conseguir detectar, exibirá uma mensagem e continuará a tentativa de indexação.

2) Tornar `serena.sh` executável (se necessário)

  chmod +x serena.sh

3) Iniciar o MCP server (modo HTTP streamable, porta 9121)

  uvx --from git+https://github.com/oraios/serena serena start-mcp-server --transport streamable-http --port 9121

  ou, se instalou localmente:

  uv run serena start-mcp-server --transport streamable-http --port 9121

4) Iniciar em stdio (quando o cliente for o responsável por iniciar o servidor, geralmente não é necessário):

  uvx --from git+https://github.com/oraios/serena serena start-mcp-server

5) Verificar se o servidor está rodando

  ps aux | grep start-mcp-server
  ss -lntp | grep 9121

6) Integração sugerida com o fluxo de criação de features

  - Após criar `features/<nome-da-sessao>`, chame:

    ./serena.sh features/<nome-da-sessao>

    - O `serena.sh` também pode ser usado por subpastas para indexar apenas um worktree específico (ex.: `./serena.sh features/<sessao>/<subpasta>`).

  Uso avançado / dicas

    - Logs do MCP: `/tmp/serena_mcp.log`
    - Se quiser evitar que o script tente iniciar o MCP (caso prefira rodar manualmente), execute com a variável de ambiente `SERENA_NO_START=1 ./serena.sh <caminho>` (o script respeita essa variável).

  - Se desejar indexar cada worktree/subpasta criada individualmente:

    ./serena.sh features/<nome-da-sessao>/<subpasta>

7) Observações

  - O comando `serena project index` pode criar automaticamente um projeto mínimo quando necessário.
  - Para que ferramentas de símbolo (find_symbol, LSP, etc.) funcionem plenamente, garanta que a pasta contenha arquivos fonte suportados ou configure as linguagens no `.serena/project.yml` via dashboard ou manualmente.

---
Gerado automaticamente pelo agente — posso ajustar o conteúdo ou formatar em Markdown diferente se preferir.
