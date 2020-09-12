# danbelden/alpine-go114-goimports

A docker image to run goimports on an alpine base image with Go `1.14.9`

- Alpine
- Go 1.14.9
- Goimports

## Examples

### Docker

```
$ docker run --rm --interactive --tty --volume "$PWD:/app" danbelden/alpine-go114-goimports:latest -w $(find . -type f -name '*.go' -not -path "./vendor/*")
```

### Make

```
# Makefile

.PHONY: imports-docker
imports: ## Run code cleanup with goimports & docker
	@docker run --rm --interactive --tty \
		--volume $(PWD):/app \
		danbelden/alpine-go114-goimports:latest -w $$(find . -type f -name '*.go' -not -path "./vendor/*")
```
```
$ make imports
$
```
