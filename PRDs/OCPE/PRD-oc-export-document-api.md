# PRD-oc-export-document-api

## Escopo
Analise do servico `oc-export-document-api` com foco em tecnologias/dependencias e melhor combinacao de agentes/skills.

## Fontes avaliadas
- `projetos/oc-all-solution/services/oc-export-document-api/requirements.txt`
- `projetos/oc-all-solution/services/oc-export-document-api/app.py`
- `projetos/oc-all-solution/services/oc-export-document-api/pyproject.toml`
- Agentes: `.agent/agents/*.md`
- Skills: `.agent/skills/*`

## Matriz de tecnologias, agentes e skills
| Tecnologia/Dependencia | Evidencia no projeto | Melhor(es) agente(s) | Melhor(es) skill(s) | Avaliacao de aderencia |
|---|---|---|---|---|
| FastAPI | `requirements.txt`, `from fastapi import FastAPI` em `app.py` | `backend-specialist`, `debugger` | `fastapi-pro`, `api-patterns`, `python-pro` | Alta: API Python assincrona, desenho de endpoints e manutencao backend.
| Uvicorn | `uvicorn[standard]` | `backend-specialist`, `devops-engineer` | `python-pro`, `deployment-procedures` | Alta: execucao da API e configuracao de runtime/deploy.
| SQLAlchemy + asyncpg + psycopg2-binary | `requirements.txt` | `database-architect`, `backend-specialist` | `database-design`, `postgresql`, `sql-pro` | Alta: modelagem/queries/migracoes e tuning de acesso ao Postgres.
| AWS boto3 (SQS) | `boto3` em `requirements.txt` e fluxo SQS em `app.py` | `backend-specialist`, `devops-engineer` | `aws-skills`, `api-patterns` | Media-Alta: integracao de mensageria e operacao em ambiente cloud.
| Pipeline DOCX/PDF (docxtpl, python-docx, PyPDF2, reportlab, pdf2image) | `requirements.txt` e uso direto em `app.py` | `backend-specialist`, `performance-optimizer`, `test-engineer` | `python-patterns`, `performance-profiling`, `python-testing-patterns` | Alta: fluxo intensivo de IO/CPU precisa robustez e testes de regressao.
| Qualidade de codigo (ruff, black, pytest, pre-commit) | `pyproject.toml`, `requirements.txt` | `test-engineer`, `qa-automation-engineer` | `testing-patterns`, `lint-and-validate`, `python-testing-patterns` | Alta: cobertura de testes e padronizacao de estilo.
| Docker/Container runtime (Dockerfiles + compose) | `Dockerfile*` e `docker-compose*.yml` no servico | `devops-engineer` | `docker-expert`, `deployment-procedures` | Alta: build/release/reproducibilidade em ambientes certi-dev/pb.

## Recomendacao operacional
- Para features backend: `backend-specialist` + skills `fastapi-pro` e `api-patterns`.
- Para banco e performance de query: `database-architect` + skills `database-design` e `postgresql`.
- Para estabilidade de entrega: `test-engineer` + `devops-engineer` com skills `testing-patterns` e `docker-expert`.
