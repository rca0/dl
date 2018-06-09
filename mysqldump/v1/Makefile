SHELL = /bin/bash

VERSION ?= latest
IMAGE ?= rca0/mysqldump

build:
	docker build --force-rm --no-cache -t $(IMAGE):$(VERSION) .

.PHONY: 
	build
