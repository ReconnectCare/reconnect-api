.PHONY: help

AWS_REGION = us-west-2

APP_NAME := reconnect-api
BUILD := $(shell git rev-parse --short HEAD)

IS_PROD := $(filter prod, $(MAKECMDGOALS))
ENV := $(if $(IS_PROD),reconnect-api-production,reconnect-api-staging)
image_tag := $(if $(IS_PROD),production,latest)

PRODUCTION_KEY = `cat ../config/credentials/production.key`

help:
	@echo "$(APP_NAME):$(BUILD)"
	@echo "  Deploying to $(ENV)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prod: ## Set the deploy target to prod
	@echo "Setting environment to production"

clean:
	rm docker-compose.yml

build-image: ## Build a new docker image
	pack build reconnect-api --env NODE_ENV=production --env RAILS_ENV=production --env RAILS_MASTER_KEY=$(PRODUCTION_KEY) --path ../ --buildpack ./ruby-buildpack --descriptor project.toml --builder paketobuildpacks/builder:full

tag-image: ## Tag the image for AWS
	docker tag reconnect-api:latest 879538747604.dkr.ecr.us-east-1.amazonaws.com/reconnect-api:$(image_tag)

docker-login: ## Login to AWS docker repo
	aws ecr get-login-password --profile reconnect-api --region us-west-2 | docker login --username AWS --password-stdin 879538747604.dkr.ecr.us-east-1.amazonaws.com

deploy-image: tag-image docker-login ## Send image to AWS
	docker push 879538747604.dkr.ecr.us-east-1.amazonaws.com/reconnect-api:$(image_tag)

deploy: clean docker-compose.yml ## update the EB ENV
	eb deploy $(ENV)

migrate: ## Run rails db:migrate
	eb ssh $(ENV) --no-verify-ssl -n 1 -c "cd /var/app/current && sudo docker-compose exec -T web launcher 'rails db:migrate'"

docker-compose.yml: ## Make a compose file for the ENV
	sed -e "s/\^TAG/$(image_tag)/g" docker-compose.template.yml > docker-compose.yml
