KUBECTL25_VERSION := v1.25.16
KUBECTL25_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL25_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL25_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL25_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL25_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL25_VERSION)/bin/linux/s390x/kubectl.sha256")

KUBECTL26_VERSION := v1.26.15
KUBECTL26_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL26_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL26_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL26_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL26_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL26_VERSION)/bin/linux/s390x/kubectl.sha256")

KUBECTL27_VERSION := v1.27.13
KUBECTL27_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL27_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL27_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL27_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL27_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL27_VERSION)/bin/linux/s390x/kubectl.sha256")

KUBECTL28_VERSION := v1.28.9
KUBECTL28_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL28_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL28_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL28_VERSION)/bin/linux/amd64/kubectl.sha256")
KUBECTL28_SUM_s390x ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL28_VERSION)/bin/linux/s390x/kubectl.sha256")

KUBECTL25 := "$(KUBECTL25_VERSION):$(KUBECTL25_SUM_arm64):$(KUBECTL25_SUM_amd64):$(KUBECTL25_SUM_s390x)"
KUBECTL26 := "$(KUBECTL26_VERSION):$(KUBECTL26_SUM_arm64):$(KUBECTL26_SUM_amd64):$(KUBECTL26_SUM_s390x)"
KUBECTL27 := "$(KUBECTL27_VERSION):$(KUBECTL27_SUM_arm64):$(KUBECTL27_SUM_amd64):$(KUBECTL27_SUM_s390x)"
KUBECTL28 := "$(KUBECTL28_VERSION):$(KUBECTL28_SUM_arm64):$(KUBECTL28_SUM_amd64):$(KUBECTL28_SUM_s390x)"

KUBECTL_VERSION_INFO := "$(KUBECTL25) $(KUBECTL26) $(KUBECTL27) $(KUBECTL28)"

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg KUBECTL_VERSION_INFO=$(KUBECTL_VERSION_INFO)