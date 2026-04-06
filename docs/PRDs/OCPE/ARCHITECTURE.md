# Arquitetura do Sistema: oc-all-solution

Este documento descreve como os diferentes componentes do ecossistema OneClick se comunicam e o propósito de cada serviço no ambiente de desenvolvimento.

## 🏗️ Visão Geral

A solução é composta por uma infraestrutura base (Bancos, Mensageria, AWS Local) e um conjunto de APIs e Frontends que dependem dessa base.

### Componentes Core (Infraestrutura)
- **PostgreSQL**: Banco de dados relacional central.
- **LocalStack**: Emulação de serviços AWS (S3, SQS, SNS, DynamoDB) para desenvolvimento offline.
- **MailHog**: Servidor SMTP falso para teste de envio de e-mails.
- **SonarQube**: Ferramenta de análise estática de código e qualidade.
- **ELK Stack (Opcional)**: Elasticsearch, Logstash e Kibana para gestão de logs.

## 🔄 Fluxo de Inicialização (`cli.sh`)

O ciclo de vida do ambiente segue a ordem abaixo:

1.  **Limpeza**: Para containers órfãos e limpa o estado anterior.
2.  **Repositórios**: Realiza o checkout/update de todas as APIs listadas na pasta `services/`.
3.  **Infraestrutura**: Sobe o Postgres, LocalStack e MailHog.
4.  **Provisionamento LocalStack**: Executa o script `scripts/init.sh` para criar as filas SQS e tópicos SNS necessários para a exportação de MD.
5.  **Serviços**: Inicia as APIs e o Frontend. 
    - Serviços com `.devcontainer` são iniciados via VS Code CLI.
    - Demais serviços são iniciados como containers Docker padrão.
6.  **Indexação**: Trigger manual para o Elasticsearch popular dados iniciais.

## 📡 Comunicação entre Serviços

Os serviços utilizam o `network_mode: host` ou redes Docker compartilhadas para facilitar a comunicação via `localhost`.

- **API Gateway / OneClick PE API**: Porta 3011
- **CertiIO API**: Porta 3000
- **Frontend**: Porta 3001
- **Grafana Proxy**: Porta 3015

## 🛠️ Ferramentas de Desenvolvimento

- **Dev Containers**: Recomendado para APIs (Node/Python) para garantir que as dependências (husky, npm, python env) sejam consistentes.
- **Awslocal**: CLI para interagir com o LocalStack de forma transparente.

---
*Atualizado em: 2026-02-24*
