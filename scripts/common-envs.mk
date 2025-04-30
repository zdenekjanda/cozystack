REGISTRY := ghcr.io/cozystack/cozystack
PUSH := 1
LOAD := 0
COZYSTACK_VERSION = $(patsubst v%,%,$(shell git describe --tags))
TAG = $(shell git describe --tags --exact-match 2>/dev/null || echo latest)

# Returns 'latest' if the git tag is not assigned, otherwise returns the provided value
define settag
$(if $(filter $(TAG),latest),latest,$(1))
endef

ifeq ($(COZYSTACK_VERSION),)
    $(shell git remote add upstream https://github.com/cozystack/cozystack.git || true)
    $(shell git fetch upstream --tags)
    COZYSTACK_VERSION = $(patsubst v%,%,$(shell git describe --tags))
endif

# Calculate PLATFORM based on current docker daemon arch
ifndef PLATFORM
  DOCKER_DAEMON_ARCH := $(shell docker info --format='{{.Architecture}}')
  ifeq ($(DOCKER_DAEMON_ARCH),x86_64)
      PLATFORM := linux/amd64
  else ifeq ($(DOCKER_DAEMON_ARCH),aarch64)
      PLATFORM := linux/arm64
  else
      $(error Unsupported architecture: "$(DOCKER_DAEMON_ARCH)")
  endif
  undefine DOCKER_DAEMON_ARCH
endif
