# PRD-oc-oneclickpe-api

## Escopo
Analise do servico `oc-oneclickpe-api` (Node.js + TypeScript) com foco em dependencias e mapeamento de agentes/skills.

## Fontes avaliadas
- `projetos/oc-all-solution/services/oc-oneclickpe-api/package.json`
- `projetos/oc-all-solution/services/oc-oneclickpe-api/README.md`
- Agentes: `.agent/agents/*.md`
- Skills: `.agent/skills/*`

## Matriz de tecnologias, agentes e skills
| Tecnologia/Dependencia | Evidencia no projeto | Melhor(es) agente(s) | Melhor(es) skill(s) | Avaliacao de aderencia |
|---|---|---|---|---|
| Node.js + Express + TypeScript | `express`, `typescript`, scripts `tsc` | `backend-specialist`, `debugger` | `nodejs-best-practices`, `typescript-pro`, `api-patterns` | Alta: backend HTTP com tipagem e manutencao de servicos.
| ORM e banco (Sequelize + PostgreSQL) | `sequelize`, `sequelize-cli`, `pg`, `pg-hstore` | `database-architect`, `backend-specialist` | `database-design`, `postgresql`, `database-migrations-sql-migrations` | Alta: modelagem, migracoes e operacao do banco.
| Integracoes AWS e fila | `@aws-sdk/client-sns`, `@aws-sdk/client-sqs` | `backend-specialist`, `devops-engineer` | `aws-skills`, `api-design-principles` | Media-Alta: integracoes externas e resiliencia de mensageria.
| Busca/observabilidade | `@elastic/elasticsearch`, `elastic-apm-node` | `performance-optimizer`, `backend-specialist` | `observability-engineer`, `performance-profiling` | Media-Alta: tracing, monitoracao e tuning de consultas.
| Geracao de documentos (pdfmake, puppeteer, pdfkit, jsdom) | dependencias em `package.json` | `backend-specialist`, `performance-optimizer`, `test-engineer` | `nodejs-backend-patterns`, `testing-patterns`, `performance-engineer` | Alta: cadeia sensivel a regressao e custo de processamento.
| Seguranca/autenticacao (jsonwebtoken, openid-client) | dependencias em `package.json` e README | `security-auditor`, `backend-specialist` | `api-security-best-practices`, `auth-implementation-patterns` | Alta: controle de acesso e seguranca de integracao.
| Qualidade e release (ESLint, Prettier, Husky, Commitlint, Sonar) | scripts/devDependencies | `test-engineer`, `project-planner` | `lint-and-validate`, `testing-patterns`, `code-review-checklist` | Alta: governanca de codigo e confiabilidade de entregas.

## Recomendacao operacional
- Fluxo principal de desenvolvimento: `backend-specialist` + `database-architect`.
- Hardening de seguranca e integracoes: `security-auditor`.
- Estabilidade de build/test/release: `test-engineer` + `devops-engineer`.
