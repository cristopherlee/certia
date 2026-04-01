#!/bin/bash

# Script de preparação de ambiente para novas tarefas (Atalho).
# Uso: ./preparatorio.sh <nome_da_tarefa> <nome_do_projeto>

TASK_NAME=$1
PROJECT_NAME=$2

if [ -z "$TASK_NAME" ] || [ -z "$PROJECT_NAME" ]; then
    echo "Erro: Forneça o nome da tarefa e o nome do projeto como parâmetros."
    echo "Uso: ./preparatorio.sh <nome_da_tarefa> <nome_do_projeto>"
    exit 1
fi

# Chama o script interno de preparação
bash ".agent/scripts/prepare_task.sh" "$TASK_NAME" "$PROJECT_NAME"
