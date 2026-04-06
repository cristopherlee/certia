---
description: Preparação inicial de novas tarefas, criação de estrutura em tasks/ e seleção de projeto via projects.json.
---

Este workflow deve ser executado no início de qualquer nova demanda para organizar o workspace e contextualizar o agente sobre o projeto alvo.

### Passos de Execução

1. **Definição do Escopo da Tarefa**
   - **Ação**: Pergunte ao usuário: 
     - "Qual é o nome ou ID da tarefa que vamos iniciar?"
     - "Qual é a descrição desta tarefa?"
   - **Ação Complementar**: Leia o conteúdo do arquivo `projects.json` (geralmente em `~/.gemini/projects.json`), valide-o se necessário usando `.agent/scripts/verify_projects.py`, apresente a lista ao usuário e pergunte: "Para qual projeto esta tarefa se aplica?".

2. **Criação da Estrutura e Contextualização**
   - **Processamento**: 
     - Com o nome fornecido, crie a pasta correspondente: `mkdir -p tasks/<nome_da_tarefa>`.
     - **Ação Complementar**: Execute o script de preparação (root): `bash scripts/preparatorio.sh <nome_da_tarefa> <nome_do_projeto>`.
     - **Nota**: Este script realizará a clonagem e configurará a pasta `.agent` **diretamente dentro da pasta do projeto clonado** (ex: `tasks/<nome_da_tarefa>/<nome_do_projeto>/.agent/`), mantendo a raiz da tarefa limpa.

3. **Análise de Escopo e Dependências**
   - **Ação**: Utilizando os dados coletados (nome da tarefa, descrição e projeto escolhido), analise os arquivos de requisitos de produto (dentro de `docs/PRDs/<nome_do_projeto>/` ou similar) e o documento de arquitetura correspondente (ex: `architecture.md` ou `documentation/ARCHITECTURE.md` do projeto escolhido).
   - Com base nessa análise detalhada, determine explicitamente e infira, de maneira automática, os seguintes pontos:
     - Quais **microserviços** do projeto sofrerão interação ou alteração nesta tarefa.
     - Quais **agentes** serão necessários para executar a análise e a implementação. **IMPORTANTE**: Use APENAS o arquivo `AGENT_CATALOG.md` ou `x.md` na raiz para descobrir e escolher os agentes avaliando a tabela. **NÃO LEIA** a pasta `.agent/agents/` arquivo por arquivo para ser mais eficiente. **Dica**: Execute `.agent/scripts/verify_catalog.py` se tiver dúvidas sobre a integridade do catálogo.
     - Quais **skills** serão necessárias para os agentes alocados. **IMPORTANTE**: Infira os nomes das skills avaliando as associadas aos agentes na tabela do `AGENT_CATALOG.md` ou `x.md`. **NÃO LEIA** as pastas dentro de `.agent/skills/`. As pastas de agentes e skills só devem ser consultadas pelo script de cópia.

4. **Isolamento de Contexto (Ignores)**
    - **Ação**: Identifique e liste os caminhos de todos os microserviços do projeto que **não** farão parte desta implementação.
    - **Nota**: Estes microserviços devem ser informados no `task.json` (Passo 5). A atualização física dos arquivos `.geminiignore` e `.opencodeignore` será realizada de forma automática pelo script no Passo 6, visando evitar duplicidade de entradas.

5. **Consolidação do Metadata e Finalização**
   - **Ação**: Verifique o arquivo `task.json` localizado agora dentro da pasta do projeto clonado (`tasks/<nome_da_tarefa>/<projeto>/task.json`), copiado automaticamente da pasta `task_template/` da raiz.
   - **Ação Complementar**: Edite o arquivo localizado no novo destino (`tasks/<nome_da_tarefa>/<projeto>/task.json`) preenchendo o Nome, Descrição, informações do Projeto, Microserviços previstos, e as listas de Agentes e Skills inferidas no Passo 3.
   - **Regra Importante**: As arrays `"agents"` e `"skills"` no JSON gerado **NÃO PODEM ESTAR VAZIAS**. Você deve obrigatoriamente realizar a inferência solicitada no Passo 3 e escrever na estrutura JSON os nomes exatos correspondentes. Este é o passo crucial para permitir a cópia automatizada no passo seguinte.

6. **Cópia de Agentes e Skills (Finalização)**
   - **Ação**: Após a criação definitiva do arquivo JSON, efetue a cópia física de todos os recursos identificados.
   - **Execução**: Execute o comando a partir da raiz do projeto principal: 
     ```bash
     bash .agent/scripts/copy_agents_skills.sh <nome_da_tarefa>
     ```
   - **Nota**: A cópia será feita para a pasta `.agent` dentro do projeto clonado.
   - **Ação Final**: Informe ao usuário que o ambiente de tarefa foi integralmente preparado com sucesso dentro da pasta do repositório clonado.
   - Sugira a execução do workflow `/plan` para iniciar o detalhamento técnico baseado no projeto selecionado.