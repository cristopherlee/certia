# PRD - Analise de Tecnologias e Dependencias

## Projeto analisado
- Caminho real analisado: `projetos/oc-all-solution/services/oc-certiio-api`
- Solicitado pelo usuario: `projetos/oc-all-solution/oc-certiio-api`

## Fontes usadas na analise
- `projetos/oc-all-solution/services/oc-certiio-api/package.json`
- `projetos/oc-all-solution/services/oc-certiio-api/README.md`
- `projetos/oc-all-solution/services/oc-certiio-api/Dockerfile`
- `projetos/oc-all-solution/services/oc-certiio-api/bitbucket-pipelines.yml`
- `projetos/oc-all-solution/services/oc-certiio-api/tsconfig.json`

## Nota sobre agentes e skills
- Agentes encontrados em: `.agent/agents`
- Skills encontrados em: `.agent/skills`
- Nao foi encontrada a pasta `.agents/skills` no workspace.

## Tabela de tecnologias/dependencias e recomendacao de agentes/skills

| Tecnologia/Dependencia | Categoria | Evidencia no projeto | Melhores agentes | Melhores skills | Motivo da recomendacao |
|---|---|---|---|---|---|
| Node.js 18 | Runtime | `bitbucket-pipelines.yml` (`image: node:18`) | `backend-specialist`, `performance-optimizer` | `modern-javascript-patterns`, `performance-profiling` | Base de execucao do servico e alvo primario de tuning. |
| TypeScript (`typescript`) | Linguagem | `package.json` (`build: tsc -p dev`) e `tsconfig.json` | `backend-specialist`, `debugger` | `modern-javascript-patterns`, `find-bugs` | Suporte para design de API tipada e diagnostico de falhas. |
| Express (`express`) | Framework API | `package.json` dependencies | `backend-specialist`, `test-engineer` | `api-testing-observability-api-mock`, `find-bugs` | API HTTP principal, exige testes de contrato/comportamento. |
| Sequelize (`sequelize`) | ORM | `package.json` dependencies e scripts `sequelize:*` | `database-architect`, `backend-specialist` | `database-migrations-sql-migrations`, `postgresql` | Camada de persistencia e migracoes do projeto. |
| Sequelize CLI (`sequelize-cli`) | Ferramenta DB | `package.json` devDependencies | `database-architect`, `devops-engineer` | `database-migrations-sql-migrations`, `bash-linux` | Automacao de migracoes/seed em fluxo local e CI. |
| PostgreSQL (`pg`, `pg-hstore`) | Banco de dados | `package.json` dependencies e README | `database-architect`, `backend-specialist` | `postgresql`, `database-migrations-sql-migrations` | Banco oficial do servico, foco em schema e performance SQL. |
| Bcrypt (`bcrypt`, `bcryptjs`) | Seguranca/auth | `package.json` dependencies | `security-auditor`, `backend-specialist` | `security-auditor`, `find-bugs` | Hash de credenciais e validacao de configuracao segura. |
| CORS (`cors`) | API security/policy | `package.json` dependencies e variavel `CORS` no Dockerfile | `security-auditor`, `backend-specialist` | `security-auditor`, `find-bugs` | Definicao correta de politica de origem e risco de exposicao. |
| UUID (`uuid`) | Identificadores | `package.json` dependencies | `backend-specialist`, `database-architect` | `modern-javascript-patterns`, `postgresql` | Geracao de identificadores com impacto em modelagem de dados. |
| Winston (`winston`) | Logging | `package.json` dependencies | `observability-engineer`, `debugger` | `error-debugging-error-trace`, `observability-engineer` | Estruturacao de logs e triagem de incidentes. |
| Elastic APM (`elastic-apm-node`) | Observabilidade/APM | `package.json` + `node -r elastic-apm-node/start` | `observability-engineer`, `performance-optimizer` | `observability-engineer`, `error-debugging-error-trace` | Tracing de transacoes e analise de latencia/erros em producao. |
| Env CMD (`env-cmd`) | Configuracao | scripts `start:*`, `sequelize:*` | `devops-engineer`, `backend-specialist` | `bash-linux`, `cloud-devops` | Gerencia perfil de ambiente local/devcontainer. |
| Docker (multi-stage, Alpine) | Containerizacao | `Dockerfile` | `devops-engineer`, `performance-optimizer` | `cloud-devops`, `deployment-pipeline-design` | Build e runtime padronizados para deploy. |
| Bitbucket Pipelines | CI/CD | `bitbucket-pipelines.yml` | `devops-engineer`, `project-planner` | `deployment-pipeline-design`, `cicd-automation-workflow-automate` | Orquestra validacoes, release e publicacao de imagem. |
| AWS ECR / AWS CLI | Registry/deploy | passos de push no `bitbucket-pipelines.yml` | `devops-engineer`, `security-auditor` | `cloud-devops`, `security-auditor` | Publicacao de imagens com controles de credencial e rollout. |
| Trivy | Seguranca de artefato | etapa `Trivy Analysis` | `security-auditor`, `devops-engineer` | `sast-configuration`, `security-auditor` | Scanner de vulnerabilidade para filesystem/imagem. |
| `npm audit` | Dependency security | etapa `Security Audit` | `security-auditor`, `backend-specialist` | `security-auditor`, `find-bugs` | Identificacao de CVEs em dependencias npm. |
| ESLint (`eslint`, `@typescript-eslint/*`) | Qualidade de codigo | scripts `lint:*` e devDependencies | `code-archaeologist`, `backend-specialist` | `find-bugs`, `modern-javascript-patterns` | Padronizacao e prevencao de defeitos em TS/JS. |
| Prettier (`prettier`, `eslint-plugin-prettier`) | Formatacao | scripts `prettier:*` | `code-archaeologist`, `documentation-writer` | `modern-javascript-patterns`, `bash-linux` | Consistencia de estilo para manutencao colaborativa. |
| Husky + lint-staged + commitlint | Governance de commit | `prepare`, `lint-staged`, `commitlint.config.js` | `project-planner`, `devops-engineer` | `cicd-automation-workflow-automate`, `bash-linux` | Garante checks locais e convencao de commits. |
| Versionamento de release (`commit-and-tag-version`) | Release management | scripts `release*` em `package.json` | `devops-engineer`, `project-manager` | `deployment-pipeline-design`, `cicd-automation-workflow-automate` | Automatiza semver/tag e integra com fluxo de pipeline. |
| SonarQube Scanner (`sonarqube-scanner`) | Qualidade e SAST | script `sonar` e devDependencies | `security-auditor`, `test-engineer` | `sast-configuration`, `find-bugs` | Gate de qualidade e rastreio de vulnerabilidades estaticas. |
| TypeDoc (`typedoc`) | Documentacao tecnica | script `typedoc` | `documentation-writer`, `backend-specialist` | `docs-architect`, `api-documentation-generator` | Gera documentacao automatica da API/codigo TS. |
| ts-node-dev + nodemon/execMap | Desenvolvimento local | `ts-node-dev` em devDependencies + `nodemonConfig` | `debugger`, `backend-specialist` | `error-debugging-error-trace`, `modern-javascript-patterns` | Feedback rapido no ciclo de desenvolvimento e depuracao. |

## Observacoes finais
- O projeto tem perfil de API backend Node.js + TypeScript com persistencia PostgreSQL via Sequelize.
- O pipeline inclui controles de qualidade e seguranca relevantes (lint, `npm audit`, Trivy, Sonar).
- Para evolucao de confiabilidade, o melhor conjunto de apoio tende a combinar: `backend-specialist` + `database-architect` + `devops-engineer` + `security-auditor` + `observability-engineer`.
