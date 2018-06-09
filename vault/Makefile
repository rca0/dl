SHELL = /bin/bash

VERSION ?= latest
IMAGE ?= project/vault
'
build:
	docker build --force-rm --no-cache -t $(IMAGE):$(VERSION) .

.PHONY: 
	build