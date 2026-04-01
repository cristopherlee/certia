#!/bin/bash

set -e

SERENA_PORT=9121
SERENA_CMD="uvx --from git+https://github.com/oraios/serena serena start-mcp-server --transport streamable-http --port $SERENA_PORT"
SERENA_LOG="/tmp/serena_mcp.log"

is_serena_running() {
	if command -v ss >/dev/null 2>&1; then
		ss -lntp 2>/dev/null | grep -q ":${SERENA_PORT} " && return 0
	fi
	pgrep -f "serena start-mcp-server" >/dev/null 2>&1 && return 0
	return 1
}

maybe_start_serena() {
	if [ "${SERENA_NO_START:-0}" = "1" ]; then
		echo "SERENA_NO_START=1 definido; pulando tentativa de iniciar o MCP do Serena."
		return 0
	fi
	if is_serena_running; then
		echo "Serena MCP já está em execução (porta $SERENA_PORT)."
		return 0
	fi

	echo "Serena MCP não encontrado. Iniciando com: $SERENA_CMD"
	nohup sh -c "$SERENA_CMD" > "$SERENA_LOG" 2>&1 &
	sleep 1

	# aguardar até 10 segundos pela porta
	for i in {1..10}; do
		if is_serena_running; then
			echo "Serena MCP iniciado (ver $SERENA_LOG)."
			return 0
		fi
		sleep 1
	done

	echo "Falha ao detectar Serena em execução após iniciar. Ver $SERENA_LOG para detalhes." >&2
	return 1
}

#### Indexação automática do Serena (verifica/levanta MCP se necessário)
TARGET="${1:-.}"
echo "🧜‍♀️ Preparando para indexar com Serena: $TARGET"
if [ ! -d "$TARGET" ]; then
	echo "Diretório '$TARGET' não encontrado." >&2
	exit 1
fi

maybe_start_serena || true

pushd "$TARGET" >/dev/null
# TARGET_PATH=".agent"
# if [ -d "$TARGET_PATH" ]; then
# 	yes N | uvx --from git+https://github.com/oraios/serena serena project index "$TARGET_PATH" --exclude "tasks/**"
# fi

# Indexar o projeto 'certia' (raiz), ignorando tudo dentro de 'tasks/'
yes N | uvx --from git+https://github.com/oraios/serena serena project index .
popd >/dev/null