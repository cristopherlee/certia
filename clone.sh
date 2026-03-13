#!/bin/bash

# Script para clonar projetos e seus subprojetos (children)
# Alinhado com a estrutura de data/projetos.json

JSON_FILE="data/projetos.json"
TARGET_DIR="projetos"

# Cores para o output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verifica dependências
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Erro: 'jq' não encontrado. Por favor, instale-o.${NC}"
    exit 1
fi

if [ ! -f "$JSON_FILE" ]; then
    echo -e "${RED}Erro: Arquivo '$JSON_FILE' não encontrado.${NC}"
    exit 1
fi

# Função para instalar dependências
install_deps() {
    local dir=$1
    if [ -f "$dir/package.json" ]; then
        echo -e "${CYAN}--- Verificando dependências em $dir ---${NC}"
        (
            cd "$dir" || exit
            if [ -f "pnpm-lock.yaml" ] && command -v pnpm &> /dev/null; then
                echo "Executando pnpm install..."
                pnpm install
            elif [ -f "yarn.lock" ] && command -v yarn &> /dev/null; then
                echo "Executando yarn install..."
                yarn install
            elif command -v npm &> /dev/null; then
                echo "Executando npm install..."
                npm install
            else
                echo -e "${YELLOW}Gerenciador de pacotes não encontrado ou lockfile incompatível. Pulando instalação.${NC}"
            fi
        )
    fi
}

# Função para trocar para a melhor branch disponível
checkout_branch() {
    local dir=$1
    echo -e "${CYAN}Ajustando branch em $dir...${NC}"
    (
        cd "$dir" || exit
        # Tenta development, depois main, depois master
        git checkout development 2>/dev/null || \
        git checkout main 2>/dev/null || \
        git checkout master 2>/dev/null || \
        echo -e "${YELLOW}Mantendo branch padrão.${NC}"
    )
}

# 1. Carregar lista de projetos (apenas primeiro nível do JSON)
mapfile -t ALL_PROJECT_NAMES < <(jq -r '.projetos[].name' "$JSON_FILE")

if [ ${#ALL_PROJECT_NAMES[@]} -eq 0 ]; then
    echo -e "${RED}Nenhum projeto encontrado no primeiro nível de $JSON_FILE.${NC}"
    exit 1
fi

SELECTED_PROJECT=""

# 2. Lógica de seleção (parâmetro por nome, número ou lista interativa)
if [ -n "$1" ]; then
    # Se o parâmetro for um número
    if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge 1 ] && [ "$1" -le "${#ALL_PROJECT_NAMES[@]}" ]; then
        SELECTED_PROJECT="${ALL_PROJECT_NAMES[$(( $1 - 1 ))]}"
    else
        # Tenta encontrar por nome
        for p in "${ALL_PROJECT_NAMES[@]}"; do
            if [ "$p" == "$1" ]; then
                SELECTED_PROJECT="$p"
                break
            fi
        done
        if [ -z "$SELECTED_PROJECT" ]; then
            echo -e "${RED}Erro: Projeto '$1' não encontrado no primeiro nível.${NC}"
            exit 1
        fi
    fi
else
    PS3="Escolha um número (1-${#ALL_PROJECT_NAMES[@]}): "
    select opt in "${ALL_PROJECT_NAMES[@]}"; do
        if [ -n "$opt" ]; then
            SELECTED_PROJECT="$opt"
            break
        else
            echo "Opção inválida."
        fi
    done
fi

if [ -z "$SELECTED_PROJECT" ]; then exit 1; fi

# 3. Recuperar dados do projeto selecionado (Nível 1)
PROJECT_DATA=$(jq -c ".projetos[] | select(.name == \"$SELECTED_PROJECT\")" "$JSON_FILE")

# 4. Extrair TODOS os projetos que possuem atributo 'git' na árvore de forma recursiva
# Isso garante pegar filhos, netos, etc., mantendo a ordem do JSON
mapfile -t PROJECTS_WITH_GIT < <(jq -c '
    def find_git:
        if type == "object" then
            (if has("git") then {name, git} else empty end),
            (if has("children") and (.children | type == "array") then .children[] | find_git else empty end)
        else empty end;
    find_git
' <<< "$PROJECT_DATA")

if [ ${#PROJECTS_WITH_GIT[@]} -eq 0 ]; then
    echo -e "${RED}Erro: Nenhuma URL git encontrada para o projeto '$SELECTED_PROJECT'.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Iniciando fluxo para: $SELECTED_PROJECT${NC}"
echo -e "${CYAN}Total de repositórios detectados: ${#PROJECTS_WITH_GIT[@]}${NC}"

# 5. O primeiro item com Git é o Projeto Base (Solution)
BASE_JSON="${PROJECTS_WITH_GIT[0]}"
BASE_NAME=$(echo "$BASE_JSON" | jq -r '.name')
BASE_GIT=$(echo "$BASE_JSON" | jq -r '.git')

# 6. Preparar diretório 'projetos' e clonar o Base
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit

echo -e "\n${YELLOW}>>> [BASE] Clonando: $BASE_NAME${NC}"
if [ -d "$BASE_NAME" ]; then
    echo "Pasta '$BASE_NAME' já existe."
else
    if git clone "$BASE_GIT" "$BASE_NAME"; then
        checkout_branch "$BASE_NAME"
    else
        echo -e "${RED}Falha ao clonar projeto base $BASE_NAME. Abortando.${NC}"
        exit 1
    fi
fi

cd "$BASE_NAME" || exit

# 7. Preparar pasta services e .gitignore
mkdir -p services
if [ ! -f .gitignore ]; then touch .gitignore; fi
if ! grep -q "^services/" .gitignore; then
    echo -e "\n# Subprojetos gerenciados pelo clone.sh\nservices/*" >> .gitignore
    echo -e "${CYAN}.gitignore atualizado para ocultar 'services/'.${NC}"
fi

# Instala dependências do projeto base
install_deps "."

# 8. Clonar todos os demais repositórios em services/
if [ ${#PROJECTS_WITH_GIT[@]} -gt 1 ]; then
    echo -e "\n${GREEN}Clonando subprojetos em services/...${NC}"
    
    # Começa do index 1 (pula o base)
    for (( i=1; i<${#PROJECTS_WITH_GIT[@]}; i++ )); do
        CHILD_JSON="${PROJECTS_WITH_GIT[$i]}"
        CHILD_NAME=$(echo "$CHILD_JSON" | jq -r '.name')
        CHILD_GIT=$(echo "$CHILD_JSON" | jq -r '.git')

        echo -e "\n${YELLOW}>>> [SERVICE] Clonando: $CHILD_NAME${NC}"
        if [ -d "services/$CHILD_NAME" ]; then
            echo "Pasta 'services/$CHILD_NAME' já existe."
        else
            if git clone "$CHILD_GIT" "services/$CHILD_NAME"; then
                echo -e "${GREEN}Clone de $CHILD_NAME concluído.${NC}"
                checkout_branch "services/$CHILD_NAME"
                install_deps "services/$CHILD_NAME"
            else
                echo -e "${RED}AVISO: Falha ao clonar $CHILD_NAME de $CHILD_GIT${NC}"
            fi
        fi
    done
fi

echo -e "\n${GREEN}Fluxo concluído com sucesso para $SELECTED_PROJECT!${NC}"
