
TAG_PREFIX = espa
TAG_VERSION = 2.13.0

.PHONY: all clean clean.containers clean.images build.base build.external build.science centos.base centos.external centos.science base external science

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# General targets
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

all: clean

clean: clean.containers clean.images

clean.containers:
	@-./scripts/remove-all-stopped-containers.sh

clean.images:
	@-./scripts/remove-dangling-images.sh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Common
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

build.base:
	@docker build -t $(TAG_PREFIX)/base \
         -f $(SYSTEM)/base/Dockerfile .
	@docker tag $(TAG_PREFIX)/base \
        $(TAG_PREFIX)/base:$(TAG_VERSION)

build.external:
	@docker build -t $(TAG_PREFIX)/external \
         -f $(SYSTEM)/external/Dockerfile .
	@docker tag $(TAG_PREFIX)/external \
        $(TAG_PREFIX)/external:$(TAG_VERSION)

build.science:
	@docker build -t $(TAG_PREFIX)/science \
         -f $(SYSTEM)/science/Dockerfile .
	@docker tag $(TAG_PREFIX)/science \
        $(TAG_PREFIX)/science:$(TAG_VERSION)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CentOS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

centos.base:
	@SYSTEM=centos make build.base

centos.external: centos.base
	@SYSTEM=centos make build.external

centos.science: centos.external
	@SYSTEM=centos make build.science

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Shortcuts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

base: centos.base
external: centos.external
science: centos.science
