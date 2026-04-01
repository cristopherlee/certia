# Script de preparação de ambiente para novas tarefas.
# Copia arquivos globais e estrutura de configuração para a pasta da tarefa.
# Uso: ./.agent/scripts/prepare_task.sh <nome_da_tarefa> <nome_do_projeto>

TASK_NAME=$1
PROJECT_NAME=$2
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
# Isso cria a pasta tasks/TASK_NAME/PROJECT_NAME
if [ -f "$WORKSPACE_ROOT/clone.sh" ]; then
    echo "--> Executando clone.sh para o projeto $PROJECT_NAME no diretório $RELATIVE_TASK_DIR..."
    bash "$WORKSPACE_ROOT/clone.sh" "$PROJECT_NAME" "$RELATIVE_TASK_DIR"
else
    echo "--> [ERRO] clone.sh não encontrado na raiz."
    exit 1
fi

# 2. Determinar o alvo real da configuração .agent (Pasta do Projeto ou Pasta da Tarefa)
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

# 4. Copiar estrutura .agent (excluindo agents e skills) para a pasta da tarefa
if [ -d "$WORKSPACE_ROOT/.agent" ]; then
    echo "--> Copiando base .agent para $TASK_DIR/.agent/..."
    mkdir -p "$TASK_DIR/.agent"
    # Copiamos o conteúdo bruto, exceto os itens pesados que serão selecionados depois
    rsync -a --exclude='agents/' --exclude='skills/' "$WORKSPACE_ROOT/.agent/." "$TASK_DIR/.agent/"
    
    # Garantir que as pastas existam (mesmo que vazias inicialmente) para manter a estrutura padrão
    mkdir -p "$TASK_DIR/.agent/agents"
    mkdir -p "$TASK_DIR/.agent/skills"
    
    # Se houver um subdiretório de projeto, sincroniza a base rsync (sem os binários)
    if [ "$TARGET_BASE" != "$TASK_DIR" ]; then
        echo "--> Sincronizando .agent base para o subdiretório do projeto: $TARGET_BASE/.agent/..."
        mkdir -p "$TARGET_BASE/.agent"
        rsync -a --exclude='agents/' --exclude='skills/' "$TASK_DIR/.agent/." "$TARGET_BASE/.agent/"
        mkdir -p "$TARGET_BASE/.agent/agents"
        mkdir -p "$TARGET_BASE/.agent/skills"
    fi
else
    echo "--> [ERRO] Pasta .agent original não encontrada."
    exit 1
fi

echo "==> Sucesso! Ambiente da tarefa $TASK_NAME pronto em $TASK_DIR"
