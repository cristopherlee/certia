.PHONY: help prep test verify status clean clone

# ==============================================================================
# CERTIA MAKEFILE - Centralizador de Comandos
# ==============================================================================

help:
	@./certia.sh help

# Exemplo: make prep task=mmm project=OCPE
prep:
	@if [ -z "$(task)" ] || [ -z "$(project)" ]; then \
		echo "Erro: Forneça task e project (ex: make prep task=mmm project=OCPE)"; \
		exit 1; \
	fi
	@./certia.sh prep $(task) $(project)

test:
	@./certia.sh test .

verify:
	@if [ -z "$(url)" ]; then \
		echo "Erro: O comando verify requer uma URL (ex: make verify url=http://localhost:3000)"; \
		exit 1; \
	fi
	@./certia.sh verify $(url)

status:
	@./certia.sh status

# Exemplo: make clean cmd=list
clean:
	@if [ -z "$(cmd)" ]; then \
		echo "Erro: O comando clean requer um subcomando (ex: make clean cmd=list)"; \
		exit 1; \
	fi
	@./certia.sh clean $(cmd) $(task)

clone:
	@./certia.sh clone $(repo) $(dest)
