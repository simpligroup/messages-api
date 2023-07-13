# default service
service := mapi

# all our targets are phony (no files to check).
.PHONY: help up shell code build clean

help:
	@echo ""
	@echo "Usage: make [TARGET] [EXTRA_ARGUMENTS]"
	@echo "Targets:"
	@echo "  build                build project"
	@echo "  up                   start project"
	@echo "  shell                start a shell inside the container"
	@echo "  unit-tests           run unit tests"
	@echo "  integration-tests    run integration tests"
	@echo "  clean                remove the project, including containers, images, volumens, etc"

# start project
up:
	@docker-compose up

# interactive shell
shell:
	@docker-compose run --rm --service-ports $(service) /bin/bash

# open VS Code
code:
	@echo "\033[0;32mWait for the container to start before clicking the Reopen in Container button."
	@code .

create-env:
ifneq (,$(wildcard ./.env))
	@echo "Skipping step, .env file already exists"
else
	@cp ./.env.development.example ./.env
endif


# install project
build:
	@docker-compose build \
	&& echo "" \
	&& echo "Installation complete." \
	|| echo "\033[0;31mInstallation failed."

build-cache:
	@docker-compose build --no-cache \
	&& echo "" \
	&& echo "Installation complete." \
	|| echo "\033[0;31mInstallation failed."

# run unit tests
tests:
	@docker-compose run $(service) pytest --cov=src/ --cov-report=html:cover/html_dir --cov-report=xml:cover/coverage.xml --feature features -vv src/tests/ 

# uninstall project
clean:
	@docker-compose down --remove-orphans -v --rmi local 2>/dev/null \
	&& echo "\033[0;32mProject removed." \
	|| echo "\033[0;32mProject already removed."