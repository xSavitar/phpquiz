# Setup —————————————————————————————————————————————————————————————————————————
EXEC_PHP    = php
SYMFONY     = $(EXEC_PHP) bin/console
SYMFONY_BIN = symfony
DOCKER      = docker-compose
YARN        = yarn
.DEFAULT_GOAL := help

## —— 🐘 PhpQuiz Make file 🐘 ——————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
up: docker-compose.yaml ## Start the docker hub (Postgres,adminer)
	$(DOCKER) -f docker-compose.yaml up -d

down: docker-compose.yaml ## Stop the docker hub
	$(DOCKER) down --remove-orphans

dpsn: ## List Docker containers for the project
	$(DOCKER) images
	@echo "--------------------------------------------------------------------------------------------------------------"
	docker ps -a | grep "phpquiz-"
	@echo "--------------------------------------------------------------------------------------------------------------"

## —— Symfony binary 💻 ————————————————————————————————————————————————————————
serve: ## Serve the application with HTTPS support
	$(SYMFONY_BIN) serve --daemon --port=8006

unserve: ## Stop the web server
	$(SYMFONY_BIN) server:stop

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
cc: ## Clear cache
	$(SYMFONY) c:c

fix-perms: ## Fix permissions of all var files
	chmod -R 777 var/*

purge: ## Purge cache and logs
	rm -rf var/cache/* var/logs/*

load-fixtures: ## Build the db, control the schema validity, load fixtures and check the migration status
	$(SYMFONY) doctrine:cache:clear-metadata
	$(SYMFONY) doctrine:database:create --if-not-exists
	$(SYMFONY) doctrine:schema:drop --force
	$(SYMFONY) doctrine:schema:create
	$(SYMFONY) doctrine:schema:validate
	$(SYMFONY) doctrine:fixtures:load -n

run: up load-fixtures serve ## Start docker, load fixtures and start the web server

abort: down unserve ## Stop docker and the Symfony binary server