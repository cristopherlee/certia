#!/bin/bash

# ==============================================================================
# CERTIA CLI - Centralizador de Comandos do Projeto Certia
# ==============================================================================
# Script para centralizar os comandos comuns e facilitar o uso do Antigravity Kit.
# 
# Uso:
#   ./certia.sh <comando> [argumentos...]
# ==============================================================================

# Script directory
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Function: Display usage help
usage() {
    echo "=============================================================================="
    echo "  CERTIA CLI - Centralizador de Comandos"
    echo "=============================================================================="
    echo "Uso: ./certia.sh <comando> [argumentos...]"
    echo ""
    echo "Comandos Disponíveis:"
    echo "  prep <task> <project>  Prepara o ambiente para uma nova tarefa."
    echo "  test [projeto]         Executa a suíte de testes (Test Runner)."
    echo "  verify <url>           Executa a verificação completa (Security, UX, E2E, etc.)."
    echo "  status                 Mostra o status atual da sessão e do projeto."
    echo "  clean <cmd> [task]     Gerenciamento de tarefas (list, archive, remove)."
    echo "  clone [repo] [dest]    Clona um repositório legado do projeto."
    echo "  lint-kit               Valida catálogo de agentes e schema de projetos."
    echo "  manage-kit             Abre o menu interativo de gerenciamento do kit."
    echo "  clear-completed        Remove todos os arquivos de completed_tasks/."
    echo "  help                   Mostra esta mensagem de ajuda."
    echo ""
    echo "Exemplos:"
    echo "  ./certia.sh prep mmm OCPE"
    echo "  ./certia.sh test ."
    echo "  ./certia.sh status"
    echo "  ./certia.sh clean list"
    echo "=============================================================================="
}

# Handle commands
case "$1" in
    "prep")
        shift
        if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Erro: Forneça o nome da tarefa e do projeto."
            echo "Uso: ./certia.sh prep <nome_da_tarefa> <nome_do_projeto>"
            exit 1
        fi
        bash "$SCRIPT_DIR/scripts/preparatorio.sh" "$@"
        ;;

    "test")
        shift
        PROJECT_PATH=${1:-"."}
        python3 "$SCRIPT_DIR/.agent/skills/testing-patterns/scripts/test_runner.py" "$PROJECT_PATH"
        ;;

    "verify")
        shift
        if [ -z "$1" ]; then
            echo "Erro: O comando verify requer uma --url <URL>."
            echo "Uso: ./certia.sh verify <URL>"
            exit 1
        fi
        python3 "$SCRIPT_DIR/.agent/scripts/verify_all.py" "." --url "$1"
        ;;

    "status")
        python3 "$SCRIPT_DIR/.agent/scripts/session_manager.py" status
        python3 "$SCRIPT_DIR/.agent/scripts/auto_preview.py" status 2>/dev/null || true
        ;;

    "clean")
        shift
        bash "$SCRIPT_DIR/scripts/cleanup.sh" "$@"
        ;;

    "clone")
        shift
        bash "$SCRIPT_DIR/scripts/clone.sh" "$@"
        ;;
    
    "lint-kit")
        echo "Executando validação do kit..."
        python3 "$SCRIPT_DIR/.agent/scripts/verify_catalog.py"
        python3 "$SCRIPT_DIR/.agent/scripts/verify_projects.py"
        ;;

    "manage-kit")
        bash "$SCRIPT_DIR/scripts/manage_kit.sh"
        ;;

    "clear-completed")
        echo "Limpando diretório de tarefas concluídas (completed_tasks/)..."
        rm -rf "$SCRIPT_DIR/completed_tasks/"*
        echo "Concluído."
        ;;

    "help"|"--help"|"-h")
        usage
        ;;

    "")
        usage
        ;;

    *)
        echo "Erro: Comando desconhecido '$1'."
        usage
        exit 1
        ;;
esac
