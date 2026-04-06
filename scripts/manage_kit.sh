#!/bin/bash

# ==============================================================================
# ANTIGRAVITY KIT MANAGER - Menu Interativo
# ==============================================================================

# Project root (one level up from scripts/)
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

show_menu() {
    clear
    echo -e "${BLUE}==============================================================================${NC}"
    echo -e "${BLUE}  ANTIGRAVITY KIT MANAGER - Ferramentas de Integridade${NC}"
    echo -e "${BLUE}==============================================================================${NC}"
    echo -e "Escolha uma opção de validação:"
    echo ""
    echo -e "  ${GREEN}1)${NC} Lint de Agentes (Sincronização Catalog vs .agent/agents/)"
    echo -e "  ${GREEN}2)${NC} Validação de Projetos (projects.json vs Schema)"
    echo -e "  ${GREEN}3)${NC} Verificação Completa (Security, Lint, Schema, etc.)"
    echo -e "  ${RED}q)${NC} Sair"
    echo ""
    echo -e "${BLUE}==============================================================================${NC}"
}

while true; do
    show_menu
    read -p "Opção: " choice

    case "$choice" in
        1)
            echo -e "\n${YELLOW}Executando Lint de Agentes...${NC}"
            python3 "$PROJECT_ROOT/.agent/scripts/verify_catalog.py"
            read -p "Pressione Enter para voltar ao menu..."
            ;;
        2)
            echo -e "\n${YELLOW}Executando Validação de Projetos...${NC}"
            python3 "$PROJECT_ROOT/.agent/scripts/verify_projects.py"
            read -p "Pressione Enter para voltar ao menu..."
            ;;
        3)
            echo -e "\n${YELLOW}Executando Verificação Completa...${NC}"
            read -p "Informe a URL para testes (ex: http://localhost:3000): " app_url
            if [ -z "$app_url" ]; then
                echo -e "${RED}Erro: URL é necessária para verificação completa.${NC}"
            else
                python3 "$PROJECT_ROOT/.agent/scripts/verify_all.py" "." --url "$app_url"
            fi
            read -p "Pressione Enter para voltar ao menu..."
            ;;
        q|Q)
            echo -e "\nSaindo..."
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida!${NC}"
            sleep 1
            ;;
    esac
done
