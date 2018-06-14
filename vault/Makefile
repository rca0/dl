SHELL = /bin/bash

VERSION ?= latest
IMAGE ?= rca0/vault

build:
	docker build --force-rm --no-cache -t $(IMAGE):$(VERSION) .

.PHONY: 
	build