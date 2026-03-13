---
title: Política para Tarefas Full-Stack
---

Descrição:

Quando uma tarefa for identificada como full-stack, siga a prioridade e abertura de contratos abaixo.

Regras de aplicação:
- Priorize resolver as necessidades de backend antes de implementar o frontend.
- Ao identificar pontos de integração entre backend e frontend, crie contratos formais (ex.: OpenAPI, JSON Schema, Protobuf) que descrevam endpoints, formatos e expectativas de erro.
- Versione os contratos junto com o código e garanta que agentes os utilizem como fonte de verdade para gerar stubs/mocks.
- Documente claramente como os agentes devem consumir/produzir esses contratos.
