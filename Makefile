.PHONY: all

# Include environment variables
include .env
export

# Define the root directory as the directory of the Makefile
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Set help as the default target
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
	AWS_PROFILE=$(AWS_PROFILE) TF_VAR_environment=$(ENVIRONMENT) TF_VAR_project=$(PROJECT) terraform plan -var-file=${ROOT_DIR}/terraform.tfvars -out=tfplan

apply: check-env ## Apply the Terraform execution plan
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) terraform apply tfplan

graph: check-env ## Generate a Terraform graph
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) terraform graph \
	> $(ROOT_DIR)/graphs/graph.dot && \
	dot -Tpng $(ROOT_DIR)/graphs/graph.dot -o $(ROOT_DIR)/graphs/graph.png

# DANGER!: The following targets will destroy resources created by Terraform.
# Use with extreme caution.

destroy-all: check-env ## DANGER!: Destroy all resources created by Terraform. Use with extreme caution.
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) TF_VAR_environment=$(ENVIRONMENT) TF_VAR_project=$(PROJECT) terraform destroy -var-file=${ROOT_DIR}/terraform.tfvars

destroy-ec2: check-env ## DANGER!: Destroy the EC2 instance. Use with extreme caution.
	cd environments/$(ENVIRONMENT) && \
	AWS_PROFILE=$(AWS_PROFILE) terraform destroy -target=module.ec2

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