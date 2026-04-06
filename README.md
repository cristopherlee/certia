## comandos Antigravity kit

npx @vudovn/ag-kit init
npx antigravity-awesome-skills --path ./.agent/skills

## Exemplo de prompt de feature

Crie um endpoint no auth-x que retorne uma string com mensagem aleatoria positiva executandodo o workflow /fluxo.md. o nome da feature deve ser feature-[NUMERO RANDOMICO] onde o NUMERO-RANDOMICO pode ser entre 1 e 100. Ajuste o endpoint consume-hello em auth-y para consumir dessa novo endpoint do auth-x

## Uso do revision.sh

O arquivo `revision.sh` foi atualizado para receber parâmetros. Para executá-lo, utilize o seguinte comando passando os parâmetros `--feature`:

```bash
./revision.sh --feature "nome-da-feature"
```


O script irá ler os argumentos fornecidos e exibi-los no terminal.

## 🧜‍♀️ Serena (Indexação de Projeto)

O projeto utiliza o **Serena** para indexação automática de símbolos, fornecendo suporte avançado para recuperação de contexto por IA.

### Configuração
O Serena está configurado para:
- **Escopo**: Observar exclusivamente a pasta `projetos/`.
- **Exclusões Node.js**: Ignora `node_modules` e `dist`.
- **Exclusões Python**: Ignora `.venv`, `__pycache__`, `.pytest_cache` e arquivos `.pyc`.

### Como Executar
Para atualizar o índice do projeto e garantir que a IA tenha acesso aos símbolos mais recentes, execute:

```bash
bash script/serena.sh
```

A configuração detalhada pode ser encontrada em `.serena/project.yml`.