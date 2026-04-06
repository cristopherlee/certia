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

# Função auxiliar para adicionar entrada em arquivo se não existir
add_if_missing() {
    local entry="$1"
    local file="$2"
    if [ ! -f "$file" ]; then
        touch "$file"
    fi
    # Se o arquivo não estiver vazio e não terminar com newline, adiciona um
    if [ -s "$file" ] && [ "$(tail -c1 "$file" | wc -l)" -eq 0 ]; then
        echo "" >> "$file"
    fi
    if ! grep -qxF "$entry" "$file"; then
        echo "$entry" >> "$file"
    fi
}

echo "==> Preparando ambiente para a tarefa: $TASK_NAME (Projeto: $PROJECT_NAME)"

# 1. Executar o clone.sh para o projeto especificado na pasta da tarefa
if [ -f "$WORKSPACE_ROOT/scripts/clone.sh" ]; then
    echo "--> Executando clone.sh para o projeto $PROJECT_NAME no diretório $RELATIVE_TASK_DIR..."
    bash "$WORKSPACE_ROOT/scripts/clone.sh" "$PROJECT_NAME" "$RELATIVE_TASK_DIR"
else
    echo "--> [ERRO] clone.sh não encontrado em scripts/."
    exit 1
fi

# 2. Determinar o alvo real da configuração .agent
TARGET_BASE="$TASK_DIR"
if [ -d "$TASK_DIR/$PROJECT_NAME" ]; then
    TARGET_BASE="$TASK_DIR/$PROJECT_NAME"
fi

echo "--> Alvo da configuração base: $TARGET_BASE"

# 3. Copiar arquivos base de task_template (sem sobrescrever os existentes)
if [ -d "$WORKSPACE_ROOT/task_template" ]; then
    echo "--> Sincronizando arquivos de task_template de forma segura..."
    # rsync --ignore-existing copia apenas o que não existe
    rsync -a --ignore-existing "$WORKSPACE_ROOT/task_template/." "$TARGET_BASE/"
fi

# 4. Processar MICROSERVICES nos arquivos de ignore
# Espera-se que MICROSERVICES venha como uma string (ex: "api,worker,frontend")
if [ -n "$MICROSERVICES" ]; then
    echo "--> Adicionando microserviços aos arquivos de ignore..."
    IFS=',' read -ra ADDR <<< "$MICROSERVICES"
    for ms in "${ADDR[@]}"; do
        add_if_missing "services/$ms" "$TARGET_BASE/.geminiignore"
        add_if_missing "services/$ms" "$TARGET_BASE/.opencodeignore"
    done
fi

# 5. Copiar estrutura .agent de forma segura
if [ -d "$WORKSPACE_ROOT/.agent" ]; then
    echo "--> Atualizando base .agent em $TARGET_BASE/.agent/..."
    mkdir -p "$TARGET_BASE/.agent"
    # Copia as ferramentas e scripts globais (pode sobrescrever para manter atualizado)
    # Mas preserva pastas específicas da tarefa como agents/ e skills/ que podem ter customizações
    rsync -a --exclude='agents/' --exclude='skills/' --exclude='.serena/' "$WORKSPACE_ROOT/.agent/." "$TARGET_BASE/.agent/"
    
    mkdir -p "$TARGET_BASE/.agent/agents"
    mkdir -p "$TARGET_BASE/.agent/skills"
else
    echo "--> [ERRO] Pasta .agent original não encontrada."
    exit 1
fi

echo "==> Sucesso! Ambiente preparado em $TASK_DIR"
