SHELL = /bin/bash

VERSION ?= latest
IMAGE ?= rca0/go-mysqldump

build:
	docker build --force-rm --no-cache -t $(IMAGE):$(VERSION) .

.PHONY: 
	build
