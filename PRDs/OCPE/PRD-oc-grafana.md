# PRD-oc-grafana

## Escopo
Analise do servico `oc-grafana` (customizacao de imagem Grafana) com foco em dependencias e operacao.

## Fontes avaliadas
- `projetos/oc-all-solution/services/oc-grafana/package.json`
- `projetos/oc-all-solution/services/oc-grafana/Dockerfile`
- `projetos/oc-all-solution/services/oc-grafana/README.md`
- Agentes: `.agent/agents/*.md`
- Skills: `.agent/skills/*`

## Matriz de tecnologias, agentes e skills
| Tecnologia/Dependencia | Evidencia no projeto | Melhor(es) agente(s) | Melhor(es) skill(s) | Avaliacao de aderencia |
|---|---|---|---|---|
| Grafana custom image (base `grafana-certi:10.2.0`) | `Dockerfile` (`FROM .../grafana-certi:10.2.0`) | `devops-engineer`, `backend-specialist` | `docker-expert`, `grafana-dashboards`, `deployment-procedures` | Alta: servico centrado em customizacao de imagem/config do Grafana.
| Configuracao por variaveis de ambiente | `ARG`/`ENV` extensivos no `Dockerfile` | `devops-engineer` | `deployment-validation-config-validate`, `bash-linux` | Alta: controle de ambiente e portabilidade de build.
| Plugins e assets Grafana | `COPY ./lib/plugins/` e assets no `Dockerfile` | `devops-engineer`, `performance-optimizer` | `grafana-dashboards`, `observability-monitoring-monitor-setup` | Media-Alta: manutencao de plugins e impacto operacional.
| Ciclo de release de imagem | script `release` com `commit-and-tag-version`, README build/push | `devops-engineer`, `project-planner` | `cicd-automation-workflow-automate`, `deployment-pipeline-design`, `git-pr-workflows-git-workflow` | Alta: processo de versionamento/publicacao de imagem.
| Node.js package minimo (tooling) | `package.json` com dependencia principal `commit-and-tag-version` | `project-planner` | `dependency-management-deps-audit`, `clean-code` | Media: pouco codigo de runtime Node, foco mais em processo.

## Recomendacao operacional
- Para manutencao de imagem/ambientes: `devops-engineer` com `docker-expert`.
- Para observabilidade e uso do Grafana: combinar `devops-engineer` com skill `grafana-dashboards`.
- Para pipeline/release: `project-planner` + `devops-engineer`.
