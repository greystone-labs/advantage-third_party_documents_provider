export COMPOSE_PROJECT_NAME=advantage

.PHONY: build
build:
	podman-compose build

.PHONY: down
down:
	podman-compose down

.PHONY: bundle
bundle:
	podman-compose -p ${COMPOSE_PROJECT_NAME} run --rm provider bundle install -j4

.PHONY: setup
setup: build

.PHONY: serve
serve:
	echo "no implemented"

.PHONY: test
test:
	podman-compose -p ${COMPOSE_PROJECT_NAME} run --rm provider bundle exec rspec

.PHONY: guard
guard:
	podman-compose -p ${COMPOSE_PROJECT_NAME} run --rm provider bundle exec guard

.PHONY: shell
shell:
	podman-compose -p ${COMPOSE_PROJECT_NAME} run --rm provider /bin/bash

.PHONY: lint
lint:
	podman-compose run --rm provider rubocop

.PHONY: check
check: lint test
	echo 'Deployable!'
