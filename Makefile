# Copyright (C) 2015, 2016  Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

APP=portefaix
NAMESPACE=$(APP)
IMAGE=mosquitto

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

DOCKER = docker

ifneq ($(version),)
	VERSION := $(shell grep ' VERSION' ${version}/Dockerfile|awk -F" " '{ print $$3 }')
endif

all: help

help:
	@echo -e "$(OK_COLOR)==== $(APP) ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- build version=xx   : Make the Docker image"
	@echo -e "$(WARN_COLOR)- publish version=xx : Publish the image"
	@echo -e "$(WARN_COLOR)- run version=xx     : Run a container"
	@echo -e "$(WARN_COLOR)- debug version=xx   : Launch a shell"

.PHONY: build
build:
	@echo -e "$(OK_COLOR)[$(APP)] build $(NAMESPACE)/$(IMAGE):$(VERSION)$(NO_COLOR)"
	@$(DOCKER) build -t $(NAMESPACE)/$(IMAGE):${VERSION} $(version)

.PHONY: run
run:
	@echo -e "$(OK_COLOR)[$(APP)] run $(NAMESPACE)/$(IMAGE):$(VERSION)$(NO_COLOR)"
	@$(DOCKER) run --rm=true -p 9090:3000 --name $(NAMESPACE)_$(IMAGE) $(NAMESPACE)/$(IMAGE):$(VERSION)

.PHONY: debug
debug:
	@echo -e "$(OK_COLOR)[$(APP)] debug $(NAMESPACE)/$(IMAGE):$(VERSION)$(NO_COLOR)"
	@$(DOCKER) run --rm=true -it -p 9090:3000 --name $(NAMESPACE)_$(IMAGE) $(NAMESPACE)/$(IMAGE):$(VERSION) /bin/bash

.PHONY: login
login:
	@$(DOCKER) login https://index.docker.io/v1/

.PHONY: publish
publish:
	@echo -e "$(OK_COLOR)[$(APP)] Publish $(NAMESPACE)/$(IMAGE):$(VERSION)$(NO_COLOR)"
	@$(DOCKER) push $(NAMESPACE)/$(IMAGE):$(VERSION)
