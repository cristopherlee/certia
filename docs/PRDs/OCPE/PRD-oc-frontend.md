# PRD-oc-frontend

## Escopo
Analise do servico `oc-frontend` (Angular) com foco em stack, dependencias e melhores agentes/skills.

## Fontes avaliadas
- `projetos/oc-all-solution/services/oc-frontend/package.json`
- `projetos/oc-all-solution/services/oc-frontend/angular.json`
- Agentes: `.agent/agents/*.md`
- Skills: `.agent/skills/*`

## Matriz de tecnologias, agentes e skills
| Tecnologia/Dependencia | Evidencia no projeto | Melhor(es) agente(s) | Melhor(es) skill(s) | Avaliacao de aderencia |
|---|---|---|---|---|
| Angular 16 (core stack) | `@angular/*` em `package.json` | `frontend-specialist`, `code-archaeologist` | `angular`, `frontend-design`, `web-design-guidelines` | Alta: arquitetura de UI e manutencao de app SPA enterprise.
| Estado/Forms UI (NGXS, Formly, PrimeNG) | `@ngxs/*`, `@ngx-formly/*`, `primeng` | `frontend-specialist` | `angular-state-management`, `angular-ui-patterns`, `ui-skills` | Alta: modelagem de estado/formularios e componentes complexos.
| Autenticacao (JWT/OIDC) | `@auth0/angular-jwt`, `angular-oauth2-oidc` | `security-auditor`, `frontend-specialist` | `auth-implementation-patterns`, `api-security-best-practices` | Alta: fluxo de autenticacao e hardening de sessao/token.
| Realtime e visualizacao | `ngx-socket-io`, `chart.js`, `fullcalendar` | `frontend-specialist`, `performance-optimizer` | `web-performance-optimization`, `performance-profiling` | Media-Alta: atualizacao em tempo real e impacto em UX/performance.
| Testes E2E e unitarios | `cypress`, `karma`, `jasmine`, `nyc` | `qa-automation-engineer`, `test-engineer` | `webapp-testing`, `testing-patterns`, `e2e-testing-patterns` | Alta: base de validacao funcional e regressao.
| Qualidade/Padrao (ESLint, Prettier, Husky, Commitlint) | `devDependencies` e scripts | `test-engineer`, `project-planner` | `lint-and-validate`, `clean-code`, `git-pr-workflows-git-workflow` | Alta: governanca de codigo e qualidade continua.
| Build/Container/CI | `Dockerfile*`, `bitbucket-pipelines.yml`, scripts Sonar | `devops-engineer` | `docker-expert`, `deployment-pipeline-design`, `cicd-automation-workflow-automate` | Alta: entrega continua e padronizacao de ambientes.

## Recomendacao operacional
- Para evolucao da UI Angular: `frontend-specialist` com skills `angular` e `angular-state-management`.
- Para qualidade de teste: `qa-automation-engineer` + `test-engineer` com `webapp-testing`.
- Para autenticacao e seguranca frontend: `security-auditor` com `auth-implementation-patterns`.
