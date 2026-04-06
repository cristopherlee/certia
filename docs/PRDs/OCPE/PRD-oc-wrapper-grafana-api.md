# PRD-oc-wrapper-grafana-api

## Escopo
Analise do servico `oc-wrapper-grafana-api` (API Node/TypeScript para integracao com Grafana).

## Fontes avaliadas
- `projetos/oc-all-solution/services/oc-wrapper-grafana-api/package.json`
- `projetos/oc-all-solution/services/oc-wrapper-grafana-api/README.md`
- Agentes: `.agent/agents/*.md`
- Skills: `.agent/skills/*`

## Matriz de tecnologias, agentes e skills
| Tecnologia/Dependencia | Evidencia no projeto | Melhor(es) agente(s) | Melhor(es) skill(s) | Avaliacao de aderencia |
|---|---|---|---|---|
| Node.js + Express + TypeScript | `express`, `typescript`, scripts `tsc`/`start` | `backend-specialist`, `debugger` | `nodejs-best-practices`, `typescript-pro`, `api-patterns` | Alta: API de integracao e manutencao de contratos HTTP.
| Integracao com Grafana | descricao no `README.md` (wrapper de IDs/recursos Grafana) | `backend-specialist`, `devops-engineer` | `grafana-dashboards`, `api-design-principles` | Alta: dominio principal do servico.
| Banco e persistencia (Sequelize + PostgreSQL) | `sequelize`, `pg`, `pg-hstore`, scripts `sequelize:*` | `database-architect`, `backend-specialist` | `database-design`, `postgresql`, `database-migrations-sql-migrations` | Alta: schema/migracoes e confiabilidade de dados.
| Observabilidade APM | `elastic-apm-node` | `performance-optimizer`, `devops-engineer` | `observability-engineer`, `performance-profiling` | Media-Alta: diagnostico de latencia e erros.
| Chamada HTTP externa | `node-fetch` | `backend-specialist` | `error-handling-patterns`, `api-patterns` | Media: importante para resiliencia de integracoes.
| Qualidade de codigo (ESLint, Prettier, Husky, Commitlint) | scripts e devDependencies | `test-engineer`, `project-planner` | `lint-and-validate`, `testing-patterns` | Alta: padrao de qualidade e padronizacao de workflow.
| Build/execucao container | `Dockerfile*` e `docker-compose` no repositorio | `devops-engineer` | `docker-expert`, `deployment-pipeline-design` | Alta: runbook de deploy e consistencia entre ambientes.

## Recomendacao operacional
- Para backlog de API e integracoes: `backend-specialist` + `database-architect`.
- Para operacao e deploy: `devops-engineer` com `docker-expert`.
- Para confiabilidade de mudancas: `test-engineer` com `testing-patterns`.
