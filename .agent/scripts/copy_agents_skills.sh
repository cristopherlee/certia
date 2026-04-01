#!/bin/bash

# Script para copiar agentes e skills definidos no JSON da tarefa para o diretório isolado da tarefa
# Uso: ./.agent/scripts/copy_agents_skills.sh <nome_da_tarefa>

TASK_NAME=$1
# Encontrar a raiz do projeto de forma robusta a partir da localização do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TASK_DIR="$WORKSPACE_ROOT/tasks/$TASK_NAME"
JSON_FILE="$TASK_DIR/task-$TASK_NAME.json"

if [ -z "$TASK_NAME" ]; then
    echo "Erro: Forneça o nome da tarefa como parâmetro."
    exit 1
fi

if [ ! -f "$JSON_FILE" ]; then
    echo "Erro: Arquivo JSON não encontrado ($JSON_FILE)."
    exit 1
fi

# Usamos Python para facilitar a manipulação de caminhos e lógica de arquivo/pasta
python3 -c "
import json, sys, shutil, os

task_name = sys.argv[1]
workspace = sys.argv[2]
task_dir = os.path.join(workspace, 'tasks', task_name)
json_path = os.path.join(task_dir, f'task-{task_name}.json')

if not os.path.exists(json_path):
    print(f'❌ Erro: JSON não encontrado em {json_path}')
    sys.exit(1)

try:
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    project_raw = data.get('project')
    project_name = data.get('project_name')
    if not project_name:
        if isinstance(project_raw, dict):
            project_name = project_raw.get('name')
        else:
            project_name = project_raw
            
    agents = data.get('agents', [])
    skills = data.get('skills', [])

    # Determinar a raiz real do projeto principal (onde estão os agentes originais)
    # Procuramos por projects.json subindo do workspace fornecido
    main_root = workspace
    for _ in range(5):
        if os.path.exists(os.path.join(main_root, 'projects.json')):
            break
        main_root = os.path.dirname(main_root)
    
    print(f'==> Raiz principal detectada: {main_root}')

    # Determinar a raiz real do projeto dentro da tarefa
    target_project_root = task_dir
    if project_name:
        potential_path = os.path.join(task_dir, project_name)
        if os.path.exists(potential_path) and os.path.isdir(potential_path):
            target_project_root = potential_path

    print(f'==> Alvo da instalação: {target_project_root}')
    
    # Garantir que a cópia ocorra na raiz da tarefa primeiro
    task_agent_dir = os.path.join(task_dir, '.agent')
    dest_agents_dir = os.path.join(task_agent_dir, 'agents')
    dest_skills_dir = os.path.join(task_agent_dir, 'skills')
    os.makedirs(dest_agents_dir, exist_ok=True)
    os.makedirs(dest_skills_dir, exist_ok=True)

    def smart_copy(name, src_base, dest_base, is_agent=False):
        # Tenta encontrar a origem (priorizando o nome exato, depois com .md)
        paths_to_try = [name]
        if not name.endswith('.md'):
            paths_to_try.append(name + '.md')
            
        found_src = None
        for p in paths_to_try:
            full_src = os.path.join(src_base, p)
            if os.path.exists(full_src):
                found_src = full_src
                break
        
        if not found_src:
            print(f'❌ {name} não encontrado em {src_base}')
            return

        dest_name = os.path.basename(found_src)
        dest_path = os.path.join(dest_base, dest_name)

        if os.path.isdir(found_src):
            # Cópia recursiva de pasta
            if os.path.exists(dest_path):
                shutil.rmtree(dest_path)
            shutil.copytree(found_src, dest_path, dirs_exist_ok=True)
            print(f'✅ Pasta {dest_name} copiada recursivamente.')
        else:
            # Cópia de arquivo individual
            if os.path.exists(dest_path):
                os.remove(dest_path)
            shutil.copy2(found_src, dest_path)
            print(f'✅ Arquivo {dest_name} copiado.')

    print(f'--> Iniciando cópia de {len(agents)} agentes...')
    for agent in agents:
        smart_copy(agent, os.path.join(main_root, '.agent/agents'), dest_agents_dir, is_agent=True)

    print(f'--> Iniciando cópia de {len(skills)} skills...')
    for skill in skills:
        smart_copy(skill, os.path.join(main_root, '.agent/skills'), dest_skills_dir)

    # Sincronizar com o diretório do projeto, se for diferente da raiz da tarefa
    if target_project_root != task_dir:
        print(f'==> Sincronizando agentes e skills para a raiz do projeto em {target_project_root}/.agent/')
        proj_agent_dir_base = os.path.join(target_project_root, '.agent')
        os.makedirs(proj_agent_dir_base, exist_ok=True)
        
        for sub in ['agents', 'skills']:
            src_sub = os.path.join(task_agent_dir, sub)
            dst_sub = os.path.join(proj_agent_dir_base, sub)
            if os.path.exists(src_sub):
                print(f'    Sincronizando {sub}...')
                if os.path.exists(dst_sub):
                    shutil.rmtree(dst_sub)
                shutil.copytree(src_sub, dst_sub, dirs_exist_ok=True)
                print(f'    ✅ {sub} sincronizado.')
            
except Exception as e:
    print(f'❌ Erro durante a cópia: {e}')
    sys.exit(1)
" "$TASK_NAME" "$WORKSPACE_ROOT"

echo "==> Cópia finalizada com sucesso!"
