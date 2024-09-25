setup:
	bin/setup
	yarn install
	yarn build
	yarn build:css
	db-prepare
	copy-env

copy-env:
	cp -n .env.example .env || true

start:
	bin/dev

install:
	bundle check || bundle install

db-prepare:
	bin/rails db:reset

test:
	NODE_ENV=test bin/rails test

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/

lint-fix:
	bundle exec rubocop -A

.PHONY: install lint setup start test
