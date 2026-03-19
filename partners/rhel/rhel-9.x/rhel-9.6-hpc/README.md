# RHEL 9.6 HPC Install (azhpc-images)

This directory contains scripts to install the Azure HPC stack on **RHEL 9.6** (same style as the official azhpc-images for Ubuntu/AlmaLinux, but for RHEL which has no pre-built Azure HPC image).

## Requirements

- RHEL 9.6 (or compatible 9.x) VM
- Root (or sudo)
- Network access (dnf/rhui, Microsoft repos)
- Sufficient disk (~20GB+ free for full install; GCC + MPI builds)

## Quick start

```bash
# Copy the whole azhpc-images repo to the VM, then:
cd azhpc-images/partners/rhel/rhel-9.x/rhel-9.6-hpc
sudo bash install.sh
```

Full install takes ~45–90 minutes (GCC build, MPIs, Intel MKL, etc.).

## What gets installed

- Base: repos (Microsoft, EPEL, CRB), kernel-devel, Development Tools, environment-modules, HPC tuning
- Lustre client (Azure Lustre), GCC 9.2, PMIx
- MPI stack: HPC-X, MVAPICH2, Open MPI, Intel MPI (with modulefiles)
- Intel oneAPI MKL, AMD AOCL/AOCC
- Azure: AZNFS, persistent RDMA naming, udev, network config

**Skipped by default** (no GPU/InfiniBand on typical CPU-only VMs): LVM resize, NVIDIA driver/CUDA/NCCL/DCGM, DOCA/OFED. Edit `install.sh` to enable those if your VM has GPU/IB.

## Smoke test (faster)

To only verify the path and apply HPC tuning (~5–10 min):

```bash
sudo bash install_smoke_test.sh
```

## Branch / tag

These changes are on branch **`rhel9.6-support`** and tagged **`rhel9.6-v1`** in the repo. Check out that branch or tag when sharing or cloning.
