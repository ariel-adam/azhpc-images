# What Was Added for RHEL 9.6

This fork adds **RHEL 9.6** support to [Azure/azhpc-images](https://github.com/Azure/azhpc-images). Upstream only has RHEL 8.10 under `partners/rhel/`. Below is what was added or changed.

---

## 1. versions.json

**File:** `partners/rhel/versions.json`

- Added **`rhel9.6`** entries for components that are looked up by distro:
  - **doca** – same URL as rhel8.10 (rhel810 rpm).
  - **hpcx** – same tarball as rhel8.10 (redhat8).
  - **nvidia** – driver and fabricmanager (rhel8).
  - **cuda** – driver and samples (rhel8).
  - **gdrcopy** – el8 distribution.

Other components use `common` and need no change.

---

## 2. New install path: partners/rhel/rhel-9.x/rhel-9.6-hpc/

| File | Purpose |
|------|---------|
| **set_properties.sh** | TOP_DIR, COMMON_DIR, RHEL_COMMON_DIR, UTILS_DIR, **DISTRIBUTION=rhel9.6**, COMPONENT_VERSIONS from `partners/rhel/versions.json`. |
| **install_prerequisites.sh** | `dnf install -y jq`. |
| **install_utils.sh** | RHEL 9–specific: Microsoft repo (rhel/9), kernel-devel, EPEL, CodeReady Builder, Development Tools, environment-modules, build deps; no Alma Linux URLs. |
| **install_gcc.sh** | Copied from rhel-8.10; builds GCC 9.2 in `/opt/gcc-9.2.0`. |
| **install.sh** | Full install sequence; **skips** LVM resize, NVIDIA/GPU, DOCA (for CPU-only VMs). |
| **install_smoke_test.sh** | Prereqs + set_properties + install_utils + hpc-tuning only. |
| **README.md** | Quick start, requirements, what gets installed. |

---

## 3. PMIx and Slurm repo for EL9

**New file:** `partners/rhel/common/slurmel9.repo`

- Same layout as `slurmel8.repo`, baseurl points to `slurm-el9-insiders` (Microsoft).

**Modified:** `partners/rhel/common/install_pmix.sh`

- Detects **rhel9*** via `DISTRIBUTION` and uses:
  - `slurmel9.repo` and package suffix **.el9** (e.g. `pmix-4.2.9-1.el9`).
- Falls back to el8 and `slurmel8.repo` for other RHEL-family distros.

---

## 4. What the full install does (and skips)

**Runs:** prereqs → set_properties → install_utils → Lustre client (el9) → install_gcc → install_pmix → install_mpis → Intel libs → AMD libs → hpc-tuning → Azure helpers (aznfs, RDMA naming, udev, network-config) → copy_test_file, disable_cloudinit.

**Skipped by default:** LVM volume resize (image-build specific), NVIDIA driver/CUDA/NCCL/DCGM/Docker/Fabric Manager, DOCA/OFED. You can uncomment or add those in `install.sh` for GPU/InfiniBand VMs.

---

## 5. Branch and tag

- **Branch:** `rhel9.6-support`
- **Tag:** `rhel9.6-v1`

Clone or checkout that branch to get all of the above.
