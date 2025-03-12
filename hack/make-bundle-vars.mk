# VERSION defines the project version for the bundle.
# Update this value when you upgrade the version of your project.
# To re-generate a bundle for another specific version without changing the standard setup, you can:
# - use the VERSION as arg of the bundle target (e.g make bundle VERSION=0.0.2)
# - use environment variables to overwrite this value (e.g export VERSION=0.0.2)
VERSION ?= 4.19.0

# MAX_OCP_VERSION variable specifies the maximum supported version of OCP.
# Its purpose is to add an annotation to the CSV file, blocking OCP upgrades beyond the X+1 version.
MAX_OCP_VERSION := $(shell echo $(VERSION) | awk -F. '{print $$1"."$$2+1}')

# DEFAULT_CHANNEL defines the default channel used in the bundle.
# Add a new line here if you would like to change its default config. (E.g DEFAULT_CHANNEL = "stable")
# To re-generate a bundle for any other default channel without changing the default setup, you can:
# - use the DEFAULT_CHANNEL as arg of the bundle target (e.g make bundle DEFAULT_CHANNEL=stable)
# - use environment variables to overwrite this value (e.g export DEFAULT_CHANNEL="stable")
DEFAULT_CHANNEL ?= alpha
BUNDLE_DEFAULT_CHANNEL := --default-channel=$(DEFAULT_CHANNEL)

# CHANNELS define the bundle channels used in the bundle.
# Add a new line here if you would like to change its default config. (E.g CHANNELS = "preview,fast,stable")
# To re-generate a bundle for other specific channels without changing the standard setup, you can:
# - use the CHANNELS as arg of the bundle target (e.g make bundle CHANNELS=preview,fast,stable)
# - use environment variables to overwrite this value (e.g export CHANNELS="preview,fast,stable")
CHANNELS ?= $(DEFAULT_CHANNEL)
BUNDLE_CHANNELS := --channels=$(CHANNELS)

BUNDLE_METADATA_OPTS ?= $(BUNDLE_CHANNELS) $(BUNDLE_DEFAULT_CHANNEL)

# OPM_RENDER_OPTS will be used while rendering bundle images
OPM_RENDER_OPTS ?=

# Each CSV has a replaces parameter that indicates which Operator it replaces.
# This builds a graph of CSVs that can be queried by OLM, and updates can be
# shared between channels. Channels can be thought of as entry points into
# the graph of updates:
REPLACES ?=

# Creating the New CatalogSource requires publishing CSVs that replace one Operator,
# but can skip several. This can be accomplished using the skipRange annotation:
SKIP_RANGE ?=

# Image URL to use all building/pushing image targets
IMAGE_REGISTRY ?= quay.io
REGISTRY_NAMESPACE ?= ocs-dev
IMAGE_TAG ?= latest
IMAGE_NAME ?= odf-operator
BUNDLE_IMAGE_NAME ?= $(IMAGE_NAME)-bundle
ODF_DEPS_BUNDLE_NAME ?= odf-dependencies
ODF_DEPS_BUNDLE_IMAGE_NAME ?= $(ODF_DEPS_BUNDLE_NAME)-bundle
CATALOG_IMAGE_NAME ?= $(IMAGE_NAME)-catalog
ODF_DEPS_CATALOG_IMAGE_NAME ?= $(ODF_DEPS_BUNDLE_NAME)-catalog

# IMG defines the image used for the operator.
IMG ?= $(IMAGE_REGISTRY)/$(REGISTRY_NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG)

# BUNDLE_IMG defines the image used for the bundle.
BUNDLE_IMG ?= $(IMAGE_REGISTRY)/$(REGISTRY_NAMESPACE)/$(BUNDLE_IMAGE_NAME):$(IMAGE_TAG)

# ODF_DEPS_BUNDLE_IMG defines the image used for the odf-dependencies bundle.
ODF_DEPS_BUNDLE_IMG ?= $(IMAGE_REGISTRY)/$(REGISTRY_NAMESPACE)/$(ODF_DEPS_BUNDLE_IMAGE_NAME):$(IMAGE_TAG)

# CATALOG_IMG defines the image used for the catalog.
CATALOG_IMG ?= $(IMAGE_REGISTRY)/$(REGISTRY_NAMESPACE)/$(CATALOG_IMAGE_NAME):$(IMAGE_TAG)

# ODF_DEPS_CATALOG_IMG defines the image used for the deps catalog.
ODF_DEPS_CATALOG_IMG ?= $(IMAGE_REGISTRY)/$(REGISTRY_NAMESPACE)/$(ODF_DEPS_CATALOG_IMAGE_NAME):$(IMAGE_TAG)

# Produce CRDs that work back to Kubernetes 1.11 (no version conversion)
CRD_OPTIONS ?= "crd"

OCS_BUNDLE_NAME ?= ocs-operator
OCS_BUNDLE_IMG_NAME ?= $(OCS_BUNDLE_NAME)-bundle
OCS_BUNDLE_VERSION ?= v4.18.0
OCS_BUNDLE_IMG_TAG ?= main-5bce897
OCS_BUNDLE_IMG_LOCATION ?= quay.io/ocs-dev
OCS_BUNDLE_IMG ?= $(OCS_BUNDLE_IMG_LOCATION)/$(OCS_BUNDLE_IMG_NAME):$(OCS_BUNDLE_IMG_TAG)

OCS_CLIENT_BUNDLE_NAME ?= ocs-client-operator
OCS_CLIENT_BUNDLE_IMG_NAME ?= $(OCS_CLIENT_BUNDLE_NAME)-bundle
OCS_CLIENT_BUNDLE_VERSION ?= v4.18.0
OCS_CLIENT_BUNDLE_IMG_TAG ?= main-284e512
OCS_CLIENT_BUNDLE_IMG_LOCATION ?= quay.io/ocs-dev
OCS_CLIENT_BUNDLE_IMG ?= $(OCS_CLIENT_BUNDLE_IMG_LOCATION)/$(OCS_CLIENT_BUNDLE_IMG_NAME):$(OCS_CLIENT_BUNDLE_IMG_TAG)

NOOBAA_BUNDLE_NAME ?= noobaa-operator
NOOBAA_BUNDLE_IMG_NAME ?= $(NOOBAA_BUNDLE_NAME)-bundle
NOOBAA_BUNDLE_VERSION ?= v5.18.0
NOOBAA_BUNDLE_IMG_TAG ?= master-20241111
NOOBAA_BUNDLE_IMG_LOCATION ?= quay.io/noobaa
NOOBAA_BUNDLE_IMG ?= $(NOOBAA_BUNDLE_IMG_LOCATION)/$(NOOBAA_BUNDLE_IMG_NAME):$(NOOBAA_BUNDLE_IMG_TAG)

CSIADDONS_BUNDLE_NAME ?= csi-addons
CSIADDONS_BUNDLE_IMG_NAME ?= k8s-bundle
CSIADDONS_BUNDLE_VERSION ?= v0.10.0
CSIADDONS_BUNDLE_IMG_TAG ?= v0.10.0
CSIADDONS_BUNDLE_IMG_LOCATION ?= quay.io/csiaddons
CSIADDONS_BUNDLE_IMG ?= $(CSIADDONS_BUNDLE_IMG_LOCATION)/$(CSIADDONS_BUNDLE_IMG_NAME):$(CSIADDONS_BUNDLE_IMG_TAG)

CEPHCSI_BUNDLE_NAME ?= cephcsi-operator
CEPHCSI_BUNDLE_IMG_NAME ?= $(CEPHCSI_BUNDLE_NAME)-bundle
CEPHCSI_BUNDLE_VERSION ?= v4.18.0
CEPHCSI_BUNDLE_IMG_TAG ?= main-85233a5
CEPHCSI_BUNDLE_IMG_LOCATION ?= quay.io/ocs-dev
CEPHCSI_BUNDLE_IMG ?= $(CEPHCSI_BUNDLE_IMG_LOCATION)/$(CEPHCSI_BUNDLE_IMG_NAME):$(CEPHCSI_BUNDLE_IMG_TAG)

IBM_BUNDLE_NAME ?= ibm-storage-odf-operator
IBM_BUNDLE_IMG_NAME ?= $(IBM_BUNDLE_NAME)-bundle
IBM_BUNDLE_VERSION ?= 1.6.0
IBM_BUNDLE_IMG_TAG ?= 1.6.0
IBM_BUNDLE_IMG_LOCATION ?= quay.io/ibmodffs
IBM_BUNDLE_IMG ?= $(IBM_BUNDLE_IMG_LOCATION)/$(IBM_BUNDLE_IMG_NAME):$(IBM_BUNDLE_IMG_TAG)

ODF_CONSOLE_IMG_NAME ?= odf-console
ODF_CONSOLE_IMG_TAG ?= latest
ODF_CONSOLE_IMG_LOCATION ?= quay.io/ocs-dev
ODF_CONSOLE_IMG ?= $(ODF_CONSOLE_IMG_LOCATION)/$(ODF_CONSOLE_IMG_NAME):$(ODF_CONSOLE_IMG_TAG)

ROOK_BUNDLE_NAME ?= rook-ceph-operator
ROOK_BUNDLE_IMG_NAME ?= $(ROOK_BUNDLE_NAME)-bundle
ROOK_BUNDLE_VERSION ?= v4.18.0
ROOK_BUNDLE_IMG_TAG ?= master-793bbb006
ROOK_BUNDLE_IMG_LOCATION ?= quay.io/ocs-dev
ROOK_BUNDLE_IMG ?= $(ROOK_BUNDLE_IMG_LOCATION)/$(ROOK_BUNDLE_IMG_NAME):$(ROOK_BUNDLE_IMG_TAG)

# To be changed when odf-prometheus-operator bundle exists
PROMETHEUS_BUNDLE_NAME ?= odf-prometheus-operator
PROMETHEUS_BUNDLE_IMG_NAME ?= $(PROMETHEUS_BUNDLE_NAME)-bundle
PROMETHEUS_BUNDLE_VERSION ?= v4.18.0
PROMETHEUS_BUNDLE_IMG_TAG ?= main-065cb99
PROMETHEUS_BUNDLE_IMG_LOCATION ?= quay.io/ocs-dev
PROMETHEUS_BUNDLE_IMG ?= $(PROMETHEUS_BUNDLE_IMG_LOCATION)/$(PROMETHEUS_BUNDLE_IMG_NAME):$(PROMETHEUS_BUNDLE_IMG_TAG)

RECIPE_BUNDLE_NAME ?= recipe
RECIPE_BUNDLE_IMG_NAME ?= $(RECIPE_BUNDLE_NAME)-bundle
RECIPE_BUNDLE_VERSION ?= v0.0.1
RECIPE_BUNDLE_IMG_TAG ?= latest
RECIPE_BUNDLE_IMG_LOCATION ?= quay.io/ramendr
RECIPE_BUNDLE_IMG ?= $(RECIPE_BUNDLE_IMG_LOCATION)/$(RECIPE_BUNDLE_IMG_NAME):$(RECIPE_BUNDLE_IMG_TAG)

# A space-separated list of bundle images (e.g. make catalog-build BUNDLE_IMGS=example.com/operator-bundle:v0.1.0 example.com/operator-bundle:v0.2.0).
# These images MUST exist in a registry and be pull-able.
BUNDLE_IMGS ?= $(BUNDLE_IMG) $(ODF_DEPS_BUNDLE_IMG) $(OCS_BUNDLE_IMG) $(OCS_CLIENT_BUNDLE_IMG) $(IBM_BUNDLE_IMG) $(NOOBAA_BUNDLE_IMG) \
			$(CSIADDONS_BUNDLE_IMG) $(CEPHCSI_BUNDLE_IMG) $(ROOK_BUNDLE_IMG) $(PROMETHEUS_BUNDLE_IMG) $(RECIPE_BUNDLE_IMG_TAG)

# Set CATALOG_BASE_IMG to an existing catalog image tag to add $BUNDLE_IMGS to that image.
ifneq ($(origin CATALOG_BASE_IMG), undefined)
FROM_INDEX_OPT := --from-index $(CATALOG_BASE_IMG)
endif

# manager env variables
OPERATOR_NAMESPACE ?= openshift-storage
OPERATOR_CATALOGSOURCE ?= odf-catalogsource
OPERATOR_CATALOGSOURCE_NAMESPACE ?= openshift-marketplace

ODF_DEPS_SUBSCRIPTION_NAME ?= $(ODF_DEPS_BUNDLE_NAME)
ODF_DEPS_SUBSCRIPTION_PACKAGE ?= $(ODF_DEPS_BUNDLE_NAME)
ODF_DEPS_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
ODF_DEPS_SUBSCRIPTION_STARTINGCSV ?= $(ODF_DEPS_BUNDLE_NAME).v$(VERSION)
ODF_DEPS_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
ODF_DEPS_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

NOOBAA_SUBSCRIPTION_NAME ?= $(NOOBAA_BUNDLE_NAME)
NOOBAA_SUBSCRIPTION_PACKAGE ?= $(NOOBAA_BUNDLE_NAME)
NOOBAA_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
NOOBAA_SUBSCRIPTION_STARTINGCSV ?= $(NOOBAA_BUNDLE_NAME).$(NOOBAA_BUNDLE_VERSION)
NOOBAA_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
NOOBAA_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

CSIADDONS_SUBSCRIPTION_NAME ?= $(CSIADDONS_BUNDLE_NAME)
CSIADDONS_SUBSCRIPTION_PACKAGE ?= $(CSIADDONS_BUNDLE_NAME)
CSIADDONS_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
CSIADDONS_SUBSCRIPTION_STARTINGCSV ?= $(CSIADDONS_BUNDLE_NAME).$(CSIADDONS_BUNDLE_VERSION)
CSIADDONS_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
CSIADDONS_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

CEPHCSI_SUBSCRIPTION_NAME ?= $(CEPHCSI_BUNDLE_NAME)
CEPHCSI_SUBSCRIPTION_PACKAGE ?= $(CEPHCSI_BUNDLE_NAME)
CEPHCSI_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
CEPHCSI_SUBSCRIPTION_STARTINGCSV ?= $(CEPHCSI_BUNDLE_NAME).$(CEPHCSI_BUNDLE_VERSION)
CEPHCSI_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
CEPHCSI_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

OCS_SUBSCRIPTION_NAME ?= $(OCS_BUNDLE_NAME)
OCS_SUBSCRIPTION_PACKAGE ?= $(OCS_BUNDLE_NAME)
OCS_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
OCS_SUBSCRIPTION_STARTINGCSV ?= $(OCS_BUNDLE_NAME).$(OCS_BUNDLE_VERSION)
OCS_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
OCS_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

OCS_CLIENT_SUBSCRIPTION_NAME ?= $(OCS_CLIENT_BUNDLE_NAME)
OCS_CLIENT_SUBSCRIPTION_PACKAGE ?= $(OCS_CLIENT_BUNDLE_NAME)
OCS_CLIENT_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
OCS_CLIENT_SUBSCRIPTION_STARTINGCSV ?= $(OCS_CLIENT_BUNDLE_NAME).$(OCS_CLIENT_BUNDLE_VERSION)
OCS_CLIENT_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
OCS_CLIENT_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

IBM_SUBSCRIPTION_NAME ?= $(IBM_BUNDLE_NAME)
IBM_SUBSCRIPTION_PACKAGE ?= $(IBM_BUNDLE_NAME)
IBM_SUBSCRIPTION_CHANNEL ?= stable-v1.6
IBM_SUBSCRIPTION_STARTINGCSV ?= $(IBM_BUNDLE_NAME).v$(IBM_BUNDLE_VERSION)
IBM_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
IBM_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

ROOK_SUBSCRIPTION_NAME ?= $(ROOK_BUNDLE_NAME)
ROOK_SUBSCRIPTION_PACKAGE ?= $(ROOK_BUNDLE_NAME)
ROOK_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
ROOK_SUBSCRIPTION_STARTINGCSV ?= $(ROOK_BUNDLE_NAME).$(ROOK_BUNDLE_VERSION)
ROOK_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
ROOK_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

PROMETHEUS_SUBSCRIPTION_NAME ?= $(PROMETHEUS_BUNDLE_NAME)
PROMETHEUS_SUBSCRIPTION_PACKAGE ?= $(PROMETHEUS_BUNDLE_NAME)
PROMETHEUS_SUBSCRIPTION_CHANNEL ?= beta
PROMETHEUS_SUBSCRIPTION_STARTINGCSV ?= $(PROMETHEUS_BUNDLE_NAME).$(PROMETHEUS_BUNDLE_VERSION)
PROMETHEUS_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
PROMETHEUS_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

RECIPE_SUBSCRIPTION_NAME ?= $(RECIPE_BUNDLE_NAME)
RECIPE_SUBSCRIPTION_PACKAGE ?= $(RECIPE_BUNDLE_NAME)
RECIPE_SUBSCRIPTION_CHANNEL ?= $(DEFAULT_CHANNEL)
RECIPE_SUBSCRIPTION_STARTINGCSV ?= $(RECIPE_BUNDLE_NAME).$(RECIPE_BUNDLE_VERSION)
RECIPE_SUBSCRIPTION_CATALOGSOURCE ?= $(OPERATOR_CATALOGSOURCE)
RECIPE_SUBSCRIPTION_CATALOGSOURCE_NAMESPACE ?= $(OPERATOR_CATALOGSOURCE_NAMESPACE)

STARTING_CSVS ?= "$(IMAGE_NAME).v$(VERSION) $(ODF_DEPS_SUBSCRIPTION_STARTINGCSV) $(OCS_SUBSCRIPTION_STARTINGCSV) $(ROOK_SUBSCRIPTION_STARTINGCSV) \
			$(NOOBAA_SUBSCRIPTION_STARTINGCSV) $(CSIADDONS_SUBSCRIPTION_STARTINGCSV) $(CEPHCSI_SUBSCRIPTION_STARTINGCSV) \
			$(OCS_CLIENT_SUBSCRIPTION_STARTINGCSV) $(PROMETHEUS_SUBSCRIPTION_STARTINGCSV) $(RECIPE_SUBSCRIPTION_STARTINGCSV)"
