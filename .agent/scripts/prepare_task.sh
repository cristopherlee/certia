#!/bin/bash
# Script de preparação de ambiente para novas tarefas.
# Copia arquivos globais e estrutura de configuração para a pasta da tarefa.
# Uso: ./.agent/scripts/prepare_task.sh <nome_da_tarefa> <nome_do_projeto> <desc> <ms> <agents> <skills>

TASK_NAME=$1
PROJECT_NAME=$2
DESCRIPTION=$3
MICROSERVICES=$4
AGENTS=$5
SKILLS=$6
WORKSPACE_ROOT=$(pwd)
TASK_DIR="$WORKSPACE_ROOT/tasks/$TASK_NAME"
RELATIVE_TASK_DIR="tasks/$TASK_NAME"

if [ -z "$TASK_NAME" ] || [ -z "$PROJECT_NAME" ]; then
    echo "Erro: Forneça o nome da tarefa e o nome do projeto como parâmetros."
    echo "Uso: $0 <nome_da_tarefa> <nome_do_projeto>"
    exit 1
fi

if [ ! -d "$TASK_DIR" ]; then
    echo "Erro: A pasta de destino $TASK_DIR não existe. Crie-a primeiro."
    exit 1
fi

echo "==> Preparando ambiente para a tarefa: $TASK_NAME (Projeto: $PROJECT_NAME)"

# 1. Executar o clone.sh para o projeto especificado na pasta da tarefa
if [ -f "$WORKSPACE_ROOT/script/clone.sh" ]; then
    echo "--> Executando clone.sh para o projeto $PROJECT_NAME no diretório $RELATIVE_TASK_DIR..."
    bash "$WORKSPACE_ROOT/script/clone.sh" "$PROJECT_NAME" "$RELATIVE_TASK_DIR"
else
    echo "--> [ERRO] clone.sh não encontrado em script/."
    exit 1
fi

# 2. Determinar o alvo real da configuração .agent
TARGET_BASE="$TASK_DIR"
if [ -d "$TASK_DIR/$PROJECT_NAME" ]; then
    TARGET_BASE="$TASK_DIR/$PROJECT_NAME"
fi

echo "--> Alvo da configuração base: $TARGET_BASE"

# 3. Copiar arquivos base de package_per_project
if [ -d "$WORKSPACE_ROOT/package_per_project" ]; then
    echo "--> Copiando arquivos de package_per_project para $TARGET_BASE..."
    cp -r "$WORKSPACE_ROOT/package_per_project/." "$TARGET_BASE/"
fi

# 4. Copiar estrutura .agent
if [ -d "$WORKSPACE_ROOT/.agent" ]; then
    echo "--> Copiando base .agent para $TARGET_BASE/.agent/..."
    mkdir -p "$TARGET_BASE/.agent"
    rsync -a --exclude='agents/' --exclude='skills/' --exclude='.serena/' "$WORKSPACE_ROOT/.agent/." "$TARGET_BASE/.agent/"
    mkdir -p "$TARGET_BASE/.agent/agents"
    mkdir -p "$TARGET_BASE/.agent/skills"
else
    echo "--> [ERRO] Pasta .agent original não encontrada."
    exit 1
fi

# 5. Cópia do Metadata task.json da raiz
echo "--> Copiando metadata task.json da raiz para $TASK_DIR/task.json"
if [ -f "$WORKSPACE_ROOT/task.json" ]; then
    cp "$WORKSPACE_ROOT/task.json" "$TASK_DIR/task.json"
else
    echo "--> [AVISO] task.json não encontrado na raiz. Criando um arquivo vazio."
    touch "$TASK_DIR/task.json"
fi

echo "==> Sucesso! Ambiente preparado em $TASK_DIR"
