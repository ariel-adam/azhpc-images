#!/bin/bash
set -ex

source ${UTILS_DIR}/utilities.sh

pmix_metadata=$(get_component_config "pmix")
PMIX_VERSION=$(jq -r '.version' <<< $pmix_metadata)
REPO_DIR="$RHEL_COMMON_DIR"

# RHEL 9 uses el9 repo and package
if [[ "$DISTRIBUTION" == rhel9* ]]; then
  SLURM_REPO=slurmel9.repo
  EL_VER=9
else
  SLURM_REPO=slurmel8.repo
  EL_VER=8
fi
cp ${REPO_DIR}/${SLURM_REPO} /etc/yum.repos.d/slurm.repo 2>/dev/null || cp ${REPO_DIR}/slurmel8.repo /etc/yum.repos.d/slurm.repo

## This package is pre-installed in all hpc images used by cyclecloud, but if customer wants to
## build an image from generic marketplace images then this package sets up the right gpg keys for PMC.
if [ ! -e /etc/yum.repos.d/microsoft-prod.repo ];then
   curl -sSL -O https://packages.microsoft.com/config/rhel/${EL_VER}/packages-microsoft-prod.rpm
   rpm -i packages-microsoft-prod.rpm
   rm -f packages-microsoft-prod.rpm
fi

# dnf config-manager --set-enabled powertools (el8)
yum -y install pmix-${PMIX_VERSION}.el${EL_VER} hwloc-devel libevent-devel munge-devel 2>/dev/null || yum -y install pmix hwloc-devel libevent-devel munge-devel

write_component_version "PMIX" ${PMIX_VERSION}
