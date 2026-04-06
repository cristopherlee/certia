#!/usr/bin/env bash
set -euo pipefail

# Carrega variáveis do arquivo mcp_config.env (na raiz do projeto) e inicia o serena.sh
# Uso: copie `mcp_config.env.example` para `mcp_config.env`, preencha os valores

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/mcp_config.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Arquivo de variáveis não encontrado: $ENV_FILE"
  echo "Crie a partir de mcp_config.env.example e preencha os valores."
  exit 1
fi

# Exporta todas as variáveis do arquivo (ignorando linhas em branco e comentários)
set -a
# shellcheck disable=SC1090
. "$ENV_FILE"
set +a

# Mata instâncias antigas
pkill -f "start-mcp-server" || true

# Se forem passados argumentos para este script, executa esses argumentos
# com o ambiente carregado (útil para rodar o comando do Serena sem criar
# dependência circular entre os scripts). Caso contrário, mantém o comportamento
# legado de chamar diretamente o serena.sh
if [ "$#" -gt 0 ]; then
  CMD="$*"
  LOG_FILE="/tmp/serena_mcp_from_env.log"
  echo "Iniciando comando com variáveis de $ENV_FILE: $CMD"
  nohup sh -c "$CMD" > "$LOG_FILE" 2>&1 &
  echo "Servidor MCP iniciado via comando (background). Log: $LOG_FILE"
else
  "$DIR/serena.sh" &
  echo "Servidor MCP iniciado (background) via serena.sh."
fi