include deploy.env

USERNAME=$(USER)
VERSION=$(shell cat Gopkg.toml | grep '\([0-9]\+\.\?\)\{3\}' -o)
commit=$(shell git rev-parse --short HEAD)

help:

.DEFAULT_GOAL := build
# Tasks do Docker
.PHONY: build build-nc push stop up run

build:
	docker build -t $(APP_NAME) .

# Build sem cache
build-nc:
	docker build --no-cache -t $(APP_NAME) .

run:
	docker container run -p 8080:8080 -d --name="$(APP_NAME)" $(APP_NAME)

up: build run

stop:
	docker container stop $(APP_NAME)

tag_with_version:
	docker tag $(APP_NAME):latest $(USERNAME)/$(APP_NAME):$(VERSION)

tag_with_commit:
	docker tag $(APP_NAME):latest $(USERNAME)/$(APP_NAME):$(commit)


publish_with_version:
	docker push $(USERNAME)/$(APP_NAME):$(VERSION)

publish_with_commit:
	docker push $(USERNAME)/$(APP_NAME):$(commit)


curl:
	@echo "Fazendo requisicao..."
	curl -sk -X GET localhost:8080/api/v1/

version:
	@echo $(VERSION)

commit:
	@echo $(commit)

### Infraestrutura:


init:
	cd ./aws; terraform init

plan:
	cd ./aws; terraform plan

# Executa o apply
exec:
	cd ./aws; export TF_VAR_commit=$(commit); \
		export $AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY); \
		export $AWS_ACCESS_KEY_ID$(AWS_ACCESS_KEY_ID); \
		terraform apply -auto-approve

destroy:
	cd ./aws; terraform destroy -auto-approve