---
description: Gerenciamento e limpeza da pasta tasks/. Permite arquivar ou remover tarefas concluídas para economizar espaço e reduzir o clutter.
---

Este workflow deve ser executado para gerenciar o acúmulo de tarefas na pasta `tasks/`.

### Passos de Execução

1. **Listagem das Tarefas Atuais**
   - **Ação**: Execute o comando para listar as tarefas existentes:
     ```bash
     bash scripts/cleanup.sh list
     ```
   - **Interação**: Apresente a lista ao usuário e pergunte: "Quais dessas tarefas você gostaria de arquivar ou remover?".

2. **Decisão de Ação (Arquivar ou Remover)**
   - **Arquivar**: Caso o usuário queira manter um backup compacto da tarefa, utilize:
     ```bash
     bash scripts/cleanup.sh archive <nome_da_tarefa>
     ```
     - **Nota**: A tarefa será compactada em `.tar.gz` na pasta `archives/` e a pasta original em `tasks/` será removida.
   - **Limpar/Remover**: Caso o usuário queira excluir permanentemente a tarefa sem backup:
     ```bash
     bash scripts/cleanup.sh remove <nome_da_tarefa>
     ```
     - **Nota**: A pasta da tarefa em `tasks/` será removida permanentemente.

3. **Verificação de Sucesso**
   - **Ação Final**: Confirme com o usuário que a operação foi concluída com sucesso e que o espaço foi liberado.

// turbo
### Comandos Rápidos
- Para listar: `bash scripts/cleanup.sh list`
- Para arquivar uma tarefa: `bash scripts/cleanup.sh archive <task_name>`
- Para remover uma tarefa: `bash scripts/cleanup.sh remove <task_name>`
