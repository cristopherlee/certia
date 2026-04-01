# Script para clonar projetos e seus subprojetos (children)
# Alinhado com a estrutura de projects.json
JSON_FILE="projects.json"
DEFAULT_TARGET_DIR="projetos"
CLONE_BRANCH="development"

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

# 1. Carregar lista de projetos
mapfile -t ALL_PROJECT_NAMES < <(jq -r '.projects[].name' "$JSON_FILE")

if [ ${#ALL_PROJECT_NAMES[@]} -eq 0 ]; then
    echo -e "${RED}Nenhum projeto encontrado no primeiro nível de $JSON_FILE.${NC}"
    exit 1
fi

SELECTED_PROJECT=""
TARGET_DIR=""

# 2. Lógica de seleção de projeto
if [ -n "$1" ]; then
    if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge 1 ] && [ "$1" -le "${#ALL_PROJECT_NAMES[@]}" ]; then
        SELECTED_PROJECT="${ALL_PROJECT_NAMES[$(( $1 - 1 ))]}"
    else
        for p in "${ALL_PROJECT_NAMES[@]}"; do
            if [ "$p" == "$1" ]; then
                SELECTED_PROJECT="$p"
                break
            fi
        done
        if [ -z "$SELECTED_PROJECT" ]; then
            echo -e "${RED}Erro: Projeto '$1' não encontrado.${NC}"
            exit 1
        fi
    fi
else
    PS3="Escolha um projeto (1-${#ALL_PROJECT_NAMES[@]}): "
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

# 3. Lógica de diretório de destino
if [ -n "$2" ]; then
    TARGET_DIR="$2"
else
    echo -e "${CYAN}Onde você gostaria de realizar o clone do Base? (Pressione Enter para usar '$DEFAULT_TARGET_DIR')${NC}"
    read -p "Caminho: " input_dir
    TARGET_DIR=${input_dir:-$DEFAULT_TARGET_DIR}
fi

# 4. Recuperar dados do projeto selecionado
PROJECT_DATA=$(jq -c ".projects[] | select(.name == \"$SELECTED_PROJECT\")" "$JSON_FILE")

# 5. Extrair repositórios recursivamente
mapfile -t PROJECTS_WITH_GIT < <(jq -c '
    def find_git:
        if type == "object" then
            (if has("git") then {name, git} else empty end),
            (if has("github") then {name, git: .github} else empty end),
            (if has("children") and (.children | type == "array") then .children[] | find_git else empty end)
        else empty end;
    find_git
' <<< "$PROJECT_DATA")

if [ ${#PROJECTS_WITH_GIT[@]} -eq 0 ]; then
    echo -e "${RED}Erro: Nenhuma URL git encontrada para '$SELECTED_PROJECT'.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Iniciando fluxo para: $SELECTED_PROJECT${NC}"
echo -e "${CYAN}Destino: $TARGET_DIR${NC}"
echo -e "${CYAN}Branch pretendida: $CLONE_BRANCH${NC}"

# 6. Clonar o Base
BASE_JSON="${PROJECTS_WITH_GIT[0]}"
BASE_NAME=$(echo "$BASE_JSON" | jq -r '.name')
BASE_GIT=$(echo "$BASE_JSON" | jq -r '.git')

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || { echo -e "${RED}Erro ao entrar no diretório $TARGET_DIR${NC}"; exit 1; }

echo -e "\n${YELLOW}>>> [BASE] Clonando: $BASE_NAME${NC}"
if [ -d "$BASE_NAME" ]; then
    echo "Pasta '$BASE_NAME' já existe."
else
    # Tenta clonar direto na branch development
    if ! git clone -b "$CLONE_BRANCH" "$BASE_GIT" "$BASE_NAME" 2>/dev/null; then
        echo -e "${YELLOW}Branch $CLONE_BRANCH não encontrada no base. Clonando branch padrão...${NC}"
        git clone "$BASE_GIT" "$BASE_NAME"
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
            if ! git clone -b "$CLONE_BRANCH" "$CHILD_GIT" "services/$CHILD_NAME" 2>/dev/null; then
                echo -e "${YELLOW}Branch $CLONE_BRANCH não encontrada em $CHILD_NAME. Clonando branch padrão...${NC}"
                git clone "$CHILD_GIT" "services/$CHILD_NAME"
            fi
        fi
    done
fi

echo -e "\n${GREEN}Fluxo concluído com sucesso para $SELECTED_PROJECT!${NC}"