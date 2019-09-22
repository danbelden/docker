# Help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Build ubuntu-elasticsearch
build-ubuntu-elasticsearch17: ## Build ubuntu-elasticsearch17
	@./tools/build.sh ubuntu-elasticsearch17
build-ubuntu-elasticsearch24: ## Build ubuntu-elasticsearch24
	@./tools/build.sh ubuntu-elasticsearch24
build-ubuntu-elasticsearch51: ## Build ubuntu-elasticsearch51
	@./tools/build.sh ubuntu-elasticsearch51
build-ubuntu-elasticsearch61: ## Build ubuntu-elasticsearch61
	@./tools/build.sh ubuntu-elasticsearch61
build-ubuntu-elasticsearch73: ## Build ubuntu-elasticsearch73
	@./tools/build.sh ubuntu-elasticsearch73

# Build ubuntu-kibana
build-ubuntu-kibana46: ## Build ubuntu-kibana46
	@./tools/build.sh ubuntu-kibana46
build-ubuntu-kibana51: ## Build ubuntu-kibana51
	@./tools/build.sh ubuntu-kibana51
build-ubuntu-kibana61: ## Build ubuntu-kibana61
	@./tools/build.sh ubuntu-kibana61

# Build logstash
build-ubuntu-logstash15: ## Build ubuntu-logstash15
	@./tools/build.sh ubuntu-logstash15
build-ubuntu-logstash24: ## Build ubuntu-logstash24
	@./tools/build.sh ubuntu-logstash24
build-ubuntu-logstash51: ## Build ubuntu-logstash51
	@./tools/build.sh ubuntu-logstash51
build-ubuntu-logstash61: ## Build ubuntu-logstash61
	@./tools/build.sh ubuntu-logstash61

# Build mysql
build-ubuntu-mysql56: ## Build ubuntu-mysql56
	@./tools/build.sh ubuntu-mysql56
build-ubuntu-mysql57: ## Build ubuntu-mysql57
	@./tools/build.sh ubuntu-mysql57

# Build php
build-ubuntu-php55-cli: ## Build ubuntu-php55-cli
	@./tools/build.sh ubuntu-php55-cli
build-ubuntu-php55-fpm-nginx: ## Build ubuntu-php55-fpm-nginx
	@./tools/build.sh ubuntu-php55-fpm-nginx
build-ubuntu-php56-cli: ## Build ubuntu-php56-cli
	@./tools/build.sh ubuntu-php56-cli
build-ubuntu-php56-fpm-nginx: ## Build ubuntu-php56-fpm-nginx
	@./tools/build.sh ubuntu-php56-fpm-nginx
build-ubuntu-php70-cli: ## Build ubuntu-php70-cli
	@./tools/build.sh ubuntu-php70-cli
build-ubuntu-php70-fpm-nginx: ## Build ubuntu-php70-fpm-nginx
	@./tools/build.sh ubuntu-php70-fpm-nginx
build-ubuntu-php72-cli: ## Build ubuntu-php72-cli
	@./tools/build.sh ubuntu-php72-cli
build-ubuntu-php72-fpm-nginx: ## Build ubuntu-php72-fpm-nginx
	@./tools/build.sh ubuntu-php72-fpm-nginx

# Build redis
build-ubuntu-redis30: ## Build ubuntu-redis30
	@./tools/build.sh ubuntu-redis30
build-ubuntu-redis32: ## Build ubuntu-redis32
	@./tools/build.sh ubuntu-redis32
build-ubuntu-redis40: ## Build ubuntu-redis40
	@./tools/build.sh ubuntu-redis40
