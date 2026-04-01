---
description: Preparação inicial de novas tarefas, criação de estrutura em tasks/ e seleção de projeto via projects.json.
---

Este workflow deve ser executado no início de qualquer nova demanda para organizar o workspace e contextualizar o agente sobre o projeto alvo.

### Passos de Execução

1. **Definição do Escopo da Tarefa**
   - **Ação**: Pergunte ao usuário: 
     - "Qual é o nome ou ID da tarefa que vamos iniciar?"
     - "Qual é a descrição desta tarefa?"
   - **Ação Complementar**: Leia o conteúdo do arquivo `projects.json` na raiz do projeto principal, apresente a lista ao usuário e pergunte: "Para qual projeto esta tarefa se aplica?".

2. **Criação da Estrutura e Contextualização**
   - **Processamento**: 
     - Com o nome fornecido, crie a pasta correspondente: `mkdir -p tasks/<nome_da_tarefa>`.
     - **Ação**: Efetue a cópia da pasta `.agent` da raiz do projeto principal para a pasta da tarefa em `tasks/<nome_da_tarefa>/.agent/`, **com exceção das pastas `agents`,  `.serena` e `skills`**.
     - **Ação Complementar**: Execute o script de preparação (root): `./preparatorio.sh <nome_da_tarefa> <nome_do_projeto>` para realizar a clonagem do projeto e configurações base.

3. **Análise de Escopo e Dependências**
   - **Ação**: Utilizando os dados coletados (nome da tarefa, descrição e projeto escolhido), analise os arquivos de requisitos de produto (dentro de `PRDs/<nome_do_projeto>/` ou similar) e o documento de arquitetura correspondente (ex: `architecture.md` ou `documentation/ARCHITECTURE.md` do projeto escolhido).
   - Com base nessa análise detalhada, determine explicitamente e infira, de maneira automática, os seguintes pontos:
     - Quais **microserviços** do projeto sofrerão interação ou alteração nesta tarefa.
     - Quais **agentes** serão necessários para executar a análise e a implementação. **IMPORTANTE**: Use APENAS o arquivo `AGENT_CATALOG.md` ou `x.md` na raiz para descobrir e escolher os agentes avaliando a tabela. **NÃO LEIA** a pasta `.agent/agents/` arquivo por arquivo para ser mais eficiente.
     - Quais **skills** serão necessárias para os agentes alocados. **IMPORTANTE**: Infira os nomes das skills avaliando as associadas aos agentes na tabela do `AGENT_CATALOG.md` ou `x.md`. **NÃO LEIA** as pastas dentro de `.agent/skills/`. As pastas de agentes e skills só devem ser consultadas pelo script de cópia.

4. **Isolamento de Contexto (Ignores)**
   - **Ação**: Identifique e liste os caminhos de todos os microserviços do projeto que **não** farão parte desta implementação.
   - Atualize ou crie os arquivos `.geminiignore` e `.opencodeignore` na raiz da tarefa (`tasks/<nome_da_tarefa>/`) ou na base do repositório para adicionar os microserviços listados, garantindo que contextos e arquivos irrelevantes sejam omitidos do contexto da IA.

5. **Consolidação do Metadata e Finalização**
   - **Ação**: Salve o Nome, Descrição, informações do Projeto, Microserviços previstos, e as listas preenchidas de Agentes e Skills em um arquivo único `task-<nome_da_tarefa>.json` dentro da pasta `tasks/<nome_da_tarefa>/`. 
   - **Regra Importante**: As arrays `"agents"` e `"skills"` no JSON gerado **NÃO PODEM ESTAR VAZIAS**. Você deve obrigatoriamente realizar a inferência solicitada no Passo 3 e escrever na estrutura JSON os nomes exatos correspondentes. Este é o passo crucial para persistir o contexto e permitir a cópia automatizada.

6. **Cópia de Agentes e Skills (Finalização)**
   - **Ação**: Após a criação definitiva do arquivo JSON, efetue a cópia física de todos os recursos identificados.
   - **Execução**: Execute o comando a partir da raiz do projeto principal: 
     ```bash
     bash .agent/scripts/copy_agents_skills.sh <nome_da_tarefa>
     ```
   - **Ação Final**: Informe ao usuário que o ambiente de tarefa foi integralmente preparado com sucesso, configurado com os microserviços alvo, regras de ignore e agentes/skills copiados e sincronizados.
   - Sugira a execução do workflow `/plan` para iniciar o detalhamento técnico baseado no projeto selecionado.