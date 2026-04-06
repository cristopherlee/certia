# Uso: ./preparatorio.sh <nome_da_tarefa> <nome_do_projeto>

TASK_NAME=$1
PROJECT_NAME=$2

if [ -z "$TASK_NAME" ] || [ -z "$PROJECT_NAME" ]; then
    echo "Erro: Forneça o nome da tarefa e do projeto."
    echo "Uso: bash scripts/preparatorio.sh <nome> <projeto>"
    exit 1
fi

# Chama o script interno de preparação passando todos os argumentos recebidos
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
bash "$SCRIPT_DIR/../.agent/scripts/prepare_task.sh" "$@"
