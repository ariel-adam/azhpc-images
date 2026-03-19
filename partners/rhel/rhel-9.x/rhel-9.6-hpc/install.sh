#!/bin/bash
# RHEL 9.6 HPC install - azhpc-images style
# Run as root from: azhpc-images/partners/rhel/rhel-9.x/rhel-9.6-hpc/
# Skips: LVM resize, NVIDIA/GPU (no GPU on Standard_D4s_v3), DOCA (no InfiniBand)
set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"

# Prereqs
./install_prerequisites.sh

export GPU=""
export SKU=""
source ./set_properties.sh

# Base packages and repos (RHEL 9)
./install_utils.sh

# Lustre client (Azure Lustre) - major version 9
$RHEL_COMMON_DIR/install_lustre_client.sh "9" || true

# GCC 9.2 (required by install_mpis; takes ~15 min)
./install_gcc.sh

# DOCA/OFED - skip on VMs without InfiniBand (e.g. Standard_D4s_v3)
# $RHEL_COMMON_DIR/install_doca.sh || true

# PMIX (required for MPI stack)
$RHEL_COMMON_DIR/install_pmix.sh || true

# MPIs: OpenMPI, MVAPICH2, Intel MPI, HPC-X
$RHEL_COMMON_DIR/install_mpis.sh

# Skip NVIDIA (no GPU): install_nvidiagpudriver, install_nccl, install_docker, install_dcgm, install_nvidia_fabric_manager

# Intel oneAPI MKL, AMD libs
$COMMON_DIR/install_intel_libs.sh || true
$COMMON_DIR/install_amd_libs.sh || true

# Cleanup downloads
rm -rf *.tgz *.bz2 *.tbz *.tar.gz *.run *.deb *_offline.sh 2>/dev/null || true
rm -rf /tmp/MLNX_OFED_LINUX* /tmp/*conf* 2>/dev/null || true
rm -rf /var/intel/ /var/cache/* 2>/dev/null || true

# HPC tuning
$RHEL_COMMON_DIR/hpc-tuning.sh

# Azure: AZNFS, persistent RDMA naming, udev, network
$COMMON_DIR/install_aznfs.sh || true
$COMMON_DIR/install_azure_persistent_rdma_naming.sh || true
$RHEL_COMMON_DIR/add-udev-rules.sh || true
$RHEL_COMMON_DIR/network-config.sh || true

# Test file and cloud-init
$COMMON_DIR/copy_test_file.sh || true
$RHEL_COMMON_DIR/disable_cloudinit.sh || true

echo "RHEL 9.6 HPC install completed. Load modules and run: module avail; mpirun --version"
exit 0
