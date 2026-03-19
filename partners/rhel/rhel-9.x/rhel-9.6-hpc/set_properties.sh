#!/bin/bash
# Set properties for RHEL 9.6 HPC install (azhpc-images)
# When run from partners/rhel/rhel-9.x/rhel-9.6-hpc, TOP_DIR is repo root.

export TOP_DIR=$(realpath ../../../../)
export COMMON_DIR=$(realpath ../../../../components)
export COMPONENT_DIR=$COMMON_DIR
export RHEL_COMMON_DIR=$(realpath ../../common)
export TEST_DIR=$(realpath ../../../../tests)
export UTILS_DIR=$(realpath ../../../../utils)
export DISTRIBUTION=rhel9.6

# Component versions from partners/rhel/versions.json
export COMPONENT_VERSIONS=$(jq -r . ../../versions.json)
export MODULE_FILES_DIRECTORY=/usr/share/Modules/modulefiles

# Architecture
export ARCHITECTURE=$(uname -m)
export ARCHITECTURE_DISTRO=$(rpm --eval '%{_arch}')
