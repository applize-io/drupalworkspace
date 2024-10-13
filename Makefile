# Load root environment variables first, then override with environment-specific ones
include .env

# Set the default environment to "dev" if not already defined
ENVIRONMENT ?= $(shell grep -s ENVIRONMENT .env | cut -d '=' -f 2 || echo "dev")


# Define paths to Docker Compose files and .env files for each environment
DOCKERFILE=config/$(ENVIRONMENT)/Dockerfile
COMPOSE_FILE=config/$(ENVIRONMENT)/compose.yml
ENV_FILE=config/$(ENVIRONMENT)/.env
PROJECT_NAME ?= $(shell grep -s PROJECT_NAME $(ENV_FILE) | cut -d '=' -f 2 || echo "drupalWorkSpace")

# Re-include environment-specific .env file to override variables
ifneq ("$(wildcard $(ENV_FILE))","")
  include $(ENV_FILE)
else
  $(error ".env file not found in config/$(ENVIRONMENT)/.env")
endif

# colorize environment
YELLOW  := \033[1;33m
RESET   := \033[0m

# Define a common docker-compose command for reuse
DOCKER_COMPOSE := docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE)


.PHONY: check
check: ## Check if necessary tools are installed
	@command -v docker > /dev/null 2>&1 || { echo >&2 "Docker is required but it's not installed. Aborting."; exit 1; }
	@command -v docker-compose > /dev/null 2>&1 || { echo >&2 "Docker Compose is required but it's not installed. Aborting."; exit 1; }

.PHONY: reset
reset: ## Stop, remove, build, and start containers for the current environment with the latest changes
	@echo "$(YELLOW)Stopping and removing containers for $(PROJECT_NAME) in $(ENVIRONMENT) environment...$(RESET)"
	$(DOCKER_COMPOSE) down -v
	@echo "$(YELLOW)Starting containers for $(PROJECT_NAME) in $(ENVIRONMENT) environment with the latest changes...$(RESET)"
	$(DOCKER_COMPOSE) up -d --build --remove-orphans

.PHONY: up
up:
	@echo "$(YELLOW)Stopping and removing containers for $(PROJECT_NAME) in $(ENVIRONMENT) environment...$(RESET)"
	$(DOCKER_COMPOSE) down --remove-orphans
	@echo "$(YELLOW)Starting containers for $(PROJECT_NAME) in $(ENVIRONMENT) environment with the latest changes...$(RESET)"
	$(DOCKER_COMPOSE) up -d

.PHONY: project
project: ## Copy files from the container to local machine
	@echo "$(YELLOW)Copying files from $(PROJECT_NAME):/opt/drupalx_temp/ to ./drupal...$(RESET)"
	docker cp $(PROJECT_NAME)_$(ENVIRONMENT)_drupal:/opt/drupalx_temp/. ./drupal

.PHONY: start
start: ## Starts the containers for the current environment without rebuilding images
	@echo "$(YELLOW)Starting containers for $(PROJECT_NAME)...$(RESET)"
	$(DOCKER_COMPOSE) start

.PHONY: stop
stop: ## Stop containers for the current environment
	@echo "$(YELLOW)Stopping containers for $(PROJECT_NAME) in $(ENVIRONMENT) environment...$(RESET)"
	$(DOCKER_COMPOSE) stop

.PHONY: prune
prune: ## Remove containers and volumes for the current environment
	@echo "$(YELLOW)Removing containers for $(PROJECT_NAME) in $(ENVIRONMENT) environment...$(RESET)"
	$(DOCKER_COMPOSE) down -v

.PHONY: logs
logs: ## Tail logs for the current environment
	@$(DOCKER_COMPOSE) logs -f $(filter-out $@,$(MAKECMDGOALS))

.PHONY: ps
ps: ## List running containers for the current environment
	@docker ps --filter name='$(PROJECT_NAME)*'

.PHONY: drush
drush: ## Execute Drush commands inside the container
	@docker exec $(shell docker ps --filter name="^/$(PROJECT_NAME)_$(ENVIRONMENT)_drupal" --format "{{.ID}}") drush $(filter-out $@,$(MAKECMDGOALS))

.PHONY: drupal
drupal: ## Execute exec commands inside the container
	@docker exec $(shell docker ps --filter name="^/$(PROJECT_NAME)_$(ENVIRONMENT)_drupal" --format "{{.ID}}") $(filter-out $@,$(MAKECMDGOALS))

.PHONY: docker-push
docker-push: ## Build and push Docker image to the registry
	@echo "$(YELLOW)Logging into the Docker registry$(RESET)"
	docker login $(DOCKER_REGISTRY)
	@echo "$(YELLOW)Building a new Docker image from the production Dockerfile$(RESET)"
	docker build --cache-from=$(DOCKER_IMAGE) -t $(DOCKER_IMAGE) -f config/prod/Dockerfile .
	@echo "$(YELLOW)Pushing the existing Docker image to the registry$(RESET)"
	docker push $(DOCKER_IMAGE)

.PHONY: db-export
db-export: ## Export the database to a specified path on the local machine
	@echo "$(YELLOW)Exporting the database to the local machine...$(RESET)"
	@docker exec $(shell docker ps --filter name='^/$(PROJECT_NAME)_$(ENVIRONMENT)_drupal' --format "{{ .ID }}") drush sql-dump --result-file=/opt/database_export.sql
	@docker cp $(PROJECT_NAME)_$(ENVIRONMENT)_drupal:/opt/database_export.sql $(EXPORT_PATH)
	@echo "$(YELLOW)Database exported to $(EXPORT_PATH)$(RESET)"

.PHONY: clean
clean: ## Remove unused Docker resources (containers, images, networks, volumes)
	@echo "$(YELLOW)Cleaning up Docker resources for $(PROJECT_NAME) in $(ENVIRONMENT) environment...$(RESET)"
	@echo "$(YELLOW)Remove stopped containers related to the project$(RESET)"
	docker container prune -f --filter "label=com.docker.compose.project=$(PROJECT_NAME)"
	@echo "$(YELLOW)Remove dangling images related to the project$(RESET)"
	docker image prune -f --filter "label=com.docker.compose.project=$(PROJECT_NAME)"
	@echo "$(YELLOW)Remove unused networks related to the project$(RESET)"
	docker network prune -f --filter "label=com.docker.compose.project=$(PROJECT_NAME)"
	@echo "$(YELLOW)Remove unused volumes related to the project$(RESET)"
	docker volume prune -f --filter "label=com.docker.compose.project=$(PROJECT_NAME)"

.PHONY: info
info: ## Display the current environment variables
	@echo "Environment: $(ENVIRONMENT)"
	@echo "Project Name: $(PROJECT_NAME)"
	@echo "Compose file: $(COMPOSE_FILE)"
	@echo "Dockerfile: $(DOCKERFILE)"
	@echo "Env file: $(ENV_FILE)"

.PHONY: help
help: ## Display available make targets with details
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk -F ': ' '{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sed 's/Makefile://g'
	@echo ""

# Catch-all target to prevent errors when no arguments are passed
%:
	@:
