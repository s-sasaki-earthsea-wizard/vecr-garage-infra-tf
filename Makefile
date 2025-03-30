.PHONY: all

# Include environment variables
include .env
export

default: help


# ------------------------------------------------------------
# Environment setup
# ------------------------------------------------------------

check-env: ## Check if required environment variables are set
	@if [ -z "$(AWS_PROFILE)" ]; then \
		echo "Error: AWS_PROFILE is not set in .env file"; \
		exit 1; \
	fi
	@if [ -z "$(ENVIRONMENT)" ]; then \
		echo "Error: ENVIRONMENT is not set in .env file"; \
		exit 1; \
	fi
	@if [ -z "$(PROJECT)" ]; then \
		echo "Error: PROJECT is not set in .env file"; \
		exit 1; \
	fi


# ------------------------------------------------------------
# Terraform commands
# ------------------------------------------------------------

init: check-env ## Initialize the Terraform project
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) terraform init

plan: check-env ## Create a Terraform execution plan
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) TF_VAR_environment=$(ENVIRONMENT) TF_VAR_project=$(PROJECT) terraform plan -var-file=../../terraform.tfvars -out=tfplan

apply: check-env ## Apply the Terraform execution plan
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) terraform apply tfplan

destroy: check-env ## Destroy the Terraform project
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) terraform destroy -var-file=../../terraform.tfvars



# ------------------------------------------------------------
# Help
# ------------------------------------------------------------

help: ## Show this help message
	@echo "------------------------------------------------------------------------------"
	@echo "Usage: make [target]"
	@echo "------------------------------------------------------------------------------"
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "------------------------------------------------------------------------------"