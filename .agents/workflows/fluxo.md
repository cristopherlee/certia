---
description: Fluxo de trabalho para criação e integração de novas funcionalidades via Git Worktrees (desenvolvimento paralelo)
---

Este workflow automatiza e padroniza a criação de um ambiente isolado para o desenvolvimento de novas features, utilizando Git Worktrees e garantindo que portas e identificadores Docker não entrem em conflito com sessões de trabalho simultâneas.

### Passos de Execução

1. **Definição e Inicialização da Sessão**
   - Solicite e defina o nome da nova sessão/feature (ex: `feat-novo-login`).
   - Certifique-se de que as branches `master` e `development` estão atualizadas nos repositórios/projetos. Caso alguma não exista não há problema.

2. **Criação da Estrutura de Worktrees**
   - o nome-da-sessao deve ter um sufixo numeral, randômico e pode ser entre 1 e 500. Você deve verificar se já existe um worktree com este número (ex: verificando na pasta features/ ou no arquivo features.json). Caso exista, procure e utilize outro número que esteja liberado.
  - Criação do diretório central: `features/<nome-da-sessao>`.
  - Após criar a pasta da feature, indexar apenas essa nova pasta com o Serena:
    - A partir da raiz do repositório, execute: `./serena.sh features/<nome-da-sessao>`
    - O script aceita caminho relativo ou absoluto; ele entra na pasta alvo e executa `serena project index` apenas nessa pasta.
   - O agente deve consultar todos os subdiretórios em `projetos/`.
   - Para **cada** subpasta encontrada (pois cada uma é um repositório Git), o agente deve criar um Git Worktree dentro de `features/<nome-da-sessao>/<subpasta>` com uma branch isolada da sessão:
     - Exemplo de comando: `git -C projetos/<pasta> worktree add ../../features/<nome-da-sessao>/<pasta> -b <nome-da-sessao>`

   - **Atualização de Inventário (features.json)**:
     - O agente deve criar ou atualizar o arquivo `features.json` na pasta `data/` do projeto com as informações da nova sessão.
     - Execute o script de rastreamento: `python3 .agent/scripts/features_tracker.py add <nome-da-sessao>`

    3. **Desenvolvimento**
       - Inicie o desenvolvimento local dentro dos worktrees criados em `features/<nome-da-sessao>/`.
      - Siga as regras definidas em `.agent/rules/` durante todo o ciclo de desenvolvimento. Essas regras orientam quais agentes usar, como mapear tecnologias por projeto, prioridades de implementação e critérios de entrega de qualidade. Veja a pasta de regras: .agent/rules/
       - Fluxo sugerido de desenvolvimento:
         - Preparar ambiente e dependências apenas para o(s) subprojeto(s) afetado(s).
         - Implementar a feature seguindo as prioridades de regra (ex.: backend antes de frontend quando aplicável).
         - Criar contratos (API/JSON/Protobuf/etc.) quando houver interação entre backend e frontend e versioná-los junto com a feature.
         - Usar somente os agentes específicos necessários para o projeto (conforme mapeamento de tecnologias em `projetos.json` / PRDs).
         - Executar testes unitários e de integração locais; documentar passos para replicação.
         - Preparar um commit claro e descritivo com instruções de verificação e, se aplicável, artefatos de contrato.

       - Referência das regras (explicação rápida):
         - `isolation-context.md` — Protege o contexto raiz do agente: o `.agent` da raiz não entra na janela de contexto do agente de feature.
         - `tech-mapping-prd.md` — Define mapeamento de tecnologias por projeto usando `projetos.json` e PRDs.
         - `agent-scope.md` — Limita o uso de agentes aos necessários para o projeto/filho em desenvolvimento.
         - `quality-delivery.md` — Critérios mínimos de qualidade e entrega para a feature.
         - `fullstack-policy.md` — Política para tarefas full-stack: priorizar backend e criar contratos de integração.

4. **Preparação para Entrega**
   - Antes de finalizar, você **OBRIGATORIAMENTE** deve perguntar ao usuário se ele aceita a implementação.

5. **Finalização e Commit**
   - Se o usuário aceitar:
      - Adicione os arquivos e comite:
         ```bash
         git add .
         git commit -m "[tipo]: implementação da funcionalidade [detalhes]"
         git push origin [nome-da-branch]
         ```

6. **Limpeza do Ambiente (Cleanup)**
   Após o push e a criação do merge request (quando a funcionalidade for aceita), execute:

   - Execute docker-compose down nas respectivas pastas que contenham arquivos docker-composer.**.yml para limpeza dos containers.
   - O agente deve iterar sobre todas as subpastas em `features/<nome-da-sessao>/` e executar o comando de remoção do Git Worktree para cada uma, garantindo que as referências sejam limpas:
     - Comando: `git -C projetos/<pasta> worktree remove ../../features/<nome-da-sessao>/<pasta> --force`
   - Remova a respectiva pasta da feature.
   - Em seguida, verifique se a pasta raiz da feature foi excluída e remova-a, caso não haja outras features ainda por serem aceitas e se necessário:
     ```bash
     rm -rf features/<nome-da-sessao>
     ```

   - **Atualização de Inventário (Limpeza)**:
     - Remova a sessão do arquivo `features.json` na pasta `data/`.
     - Execute o comando: `python3 .agent/scripts/features_tracker.py remove <nome-da-sessao>`

   - **Remoção da pasta raiz `features`**: Após remover a pasta da sessão, verifique se o diretório pai, `features/`, ficou completamente vazio. Em caso positivo, remova-o também para manter a integridade e limpeza do repositório:
     ```bash
     rmdir features 2>/dev/null || true
     ```