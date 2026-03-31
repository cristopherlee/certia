---
title: Isolamento do Contexto Raiz
---

Descrição:

O `.agent` na raiz do repositório NÃO deve ser automaticamente incluído na janela de contexto dos agentes criados para desenvolver uma feature.

Regras de aplicação:
- Sempre que um agente de sessão for instanciado dentro de `features/<nome-da-sessao>/...`, ignore referências automáticas ao `.agent` da raiz.
- Se for necessário algum dado do `.agent` da raiz, importe explicitamente apenas os arquivos necessários e registre isso no manifesto da feature.
