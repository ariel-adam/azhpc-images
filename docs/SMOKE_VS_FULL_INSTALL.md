# Smoke Test vs Full Install (azhpc-images on RHEL 9.6)

## What the Smoke Test Does

`install_smoke_test.sh` runs only:

| Step | What it does |
|------|----------------|
| `install_prerequisites.sh` | Install `jq` (for parsing versions.json). |
| `set_properties.sh` | Set TOP_DIR, COMMON_DIR, RHEL_COMMON_DIR, DISTRIBUTION=rhel9.6, etc. |
| `install_utils.sh` | Microsoft repo (RHEL 9), kernel-devel/headers, EPEL, CodeReady Builder, **Development Tools**, environment-modules, build deps (cmake, numactl, perl, azcopy, …), kernel exclude, copy KVP/torset tools. |
| `hpc-tuning.sh` | Set **kernel.pid_max = 4194304**, **vm.max_map_count = 65530** (and related HPC sysctl). |

**Result:** Base OS + build environment + HPC kernel tuning. No MPI stack built from source, no Lustre, no Intel/AMD math libs, no Azure RDMA/aznfs helpers.

**Time:** ~5–10 minutes.

---

## What the Full Install Adds (`install.sh`)

Everything above **plus**:

| Step | What it does | Approx. time |
|------|----------------|---------------|
| **Lustre client** | Azure Lustre client (amlfs) for RHEL 9. | ~2–5 min |
| **install_gcc.sh** | Build and install **GCC 9.2** into `/opt/gcc-9.2.0`. | **~15–25 min** |
| **install_pmix.sh** | Install **PMIx** (el9) from Microsoft/Slurm repo. | ~1–2 min |
| **install_mpis.sh** | Build/install **HPC-X**, **MVAPICH2**, **OpenMPI**, **Intel MPI**; modulefiles. | **~20–40 min** |
| **(skipped)** | DOCA/OFED (InfiniBand) – not run by default. | - |
| **(skipped)** | NVIDIA driver, NCCL, DCGM, Docker (no GPU by default). | - |
| **install_intel_libs.sh** | **Intel oneAPI MKL**. | ~5–15 min |
| **install_amd_libs.sh** | **AMD AOCL/AOCC** libs. | ~2–5 min |
| **hpc-tuning.sh** | (Same as smoke test.) | ~1 s |
| **install_aznfs.sh** | Azure NFS mount helper. | ~1 min |
| **install_azure_persistent_rdma_naming.sh** | Persistent RDMA device naming. | ~1 min |
| **add-udev-rules.sh**, **network-config.sh**, **copy_test_file.sh**, **disable_cloudinit.sh** | Azure HPC helpers and cleanup. | ~1 min |

**Rough total:** ~45–90 minutes.

---

## Side-by-Side Summary

| | Smoke test | Full install |
|--|------------|--------------|
| **Base + tuning** | ✅ | ✅ |
| **GCC 9.2** | ❌ | ✅ |
| **Lustre client** | ❌ | ✅ |
| **PMIx** | ❌ | ✅ |
| **MPI stack** | ❌ | ✅ HPC-X, MVAPICH2, Open MPI, Intel MPI |
| **Intel MKL** | ❌ | ✅ |
| **AMD libs** | ❌ | ✅ |
| **Azure helpers** | ❌ | ✅ |
| **NVIDIA / DOCA** | ❌ | ❌ (skipped by default) |
| **Time** | ~5–10 min | ~45–90 min |

---

## When to Use Which

- **Smoke test:** Confirm the RHEL 9.6 path works and HPC tuning is applied; minimal time.
- **Full install:** Full azhpc-images MPI stack, Lustre client, and Azure helpers.

**Commands:**

```bash
# Smoke test
cd azhpc-images/partners/rhel/rhel-9.x/rhel-9.6-hpc
sudo bash install_smoke_test.sh

# Full install
sudo bash install.sh
```
