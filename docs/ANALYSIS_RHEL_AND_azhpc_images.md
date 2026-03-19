# azhpc-images and RHEL – Short Analysis

## How azhpc-images is designed

- The repo is used to **build** Azure HPC VM images: start a VM, run install scripts, then capture the image. It is not primarily “install on my existing VM,” but the same scripts can be run manually on an existing VM.
- **RHEL** is under **partners/rhel** because Azure cannot ship pre-built RHEL HPC images with third-party components. The scripts are for you to build your own RHEL HPC image (or run them on a RHEL VM as we do).
- Upstream only has a **RHEL 8.10** path (`partners/rhel/rhel-8.x/rhel-8.10-hpc/` and `rhel8.10` in `versions.json`). There was **no RHEL 9.x** path.

## What’s needed to run on RHEL 9.6

1. **versions.json** – Add **rhel9.6** (or alias) so component lookups (doca, hpcx, nvidia, cuda, gdrcopy, etc.) work. We added `rhel9.6` entries.
2. **Install path** – A directory (e.g. `partners/rhel/rhel-9.x/rhel-9.6-hpc/`) with:
   - **set_properties.sh** – TOP_DIR, COMMON_DIR, RHEL_COMMON_DIR, DISTRIBUTION=rhel9.6, COMPONENT_VERSIONS from `partners/rhel/versions.json`.
   - **install_utils.sh** – RHEL 9 repos (Microsoft rhel/9, EPEL, CRB), kernel-devel, Development Tools, environment-modules; **no Alma Linux** URLs.
   - **install.sh** – Same order as rhel-8.10; skip LVM and optionally GPU/DOCA for CPU-only VMs.
3. **PMIx** – Repo and package for **el9** (e.g. `slurmel9.repo`, `pmix-*.el9`). We added `slurmel9.repo` and updated `install_pmix.sh` to use el8/el9 by DISTRIBUTION.
4. **Lustre** – `install_lustre_client.sh` takes a major version (e.g. `"9"`); `setup_lustre_repo.sh` uses `el$1`, so el9 works.

## Binaries vs build-from-source

- **Ubuntu:** Uses system GCC; PMIx, DOCA, NVIDIA, HPC-X tarball, Intel MPI are binaries/packages; **MVAPICH2 and Open MPI are built from source**.
- **RHEL (this fork):** Builds **GCC 9.2** from source, then same MVAPICH2/Open MPI from source; PMIx, Intel MPI, Lustre, etc. are packages or installers. So both distros build the MPI stack from source; RHEL also builds the compiler.

## Summary

To run azhpc-images on RHEL 9.6 you need: rhel9.6 in versions.json, a RHEL 9–specific install path (set_properties + install_utils + install.sh), and el9 support where distro-specific (e.g. PMIx). This fork adds all of that.
