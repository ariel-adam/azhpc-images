# How to Use This Fork (RHEL 9.6 HPC)

This fork adds **RHEL 9.6** support to [Azure/azhpc-images](https://github.com/Azure/azhpc-images). Use it to install the same HPC stack (MPI, Lustre, tuning, etc.) on a RHEL 9.6 VM.

---

## 1. Get the repo

**Option A – Clone the branch (recommended)**

```bash
git clone -b rhel9.6-support https://github.com/ariel-adam/azhpc-images.git
cd azhpc-images
```

**Option B – Clone then checkout**

```bash
git clone https://github.com/ariel-adam/azhpc-images.git
cd azhpc-images
git checkout rhel9.6-support
```

---

## 2. Copy to your RHEL 9.6 VM

From your laptop (replace `user@your-rhel-vm` with your VM user and hostname/IP):

```bash
scp -r azhpc-images user@your-rhel-vm:/tmp/
```

Or use `rsync`:

```bash
rsync -avz --exclude='.git' azhpc-images/ user@your-rhel-vm:/tmp/azhpc-images/
```

---

## 3. Run the install on the VM

SSH into the VM, then:

```bash
cd /tmp/azhpc-images/partners/rhel/rhel-9.x/rhel-9.6-hpc
sudo bash install.sh
```

- **Full install** takes about **45–90 minutes** (GCC build, MPIs, Intel MKL, etc.).
- Requires **root** (or sudo) and **network** (dnf, Microsoft repos).
- Ensure enough **free disk** (e.g. 20GB+).

---

## 4. (Optional) Quick smoke test instead

To only check the path and apply HPC tuning (~5–10 min), no MPI build:

```bash
cd /tmp/azhpc-images/partners/rhel/rhel-9.x/rhel-9.6-hpc
sudo bash install_smoke_test.sh
```

---

## What gets installed (full install)

- Base: Microsoft/EPEL/CRB repos, kernel-devel, Development Tools, environment-modules, **HPC tuning**
- **Lustre client** (Azure Lustre), **GCC 9.2**, **PMIx**
- **MPI stack:** HPC-X, MVAPICH2, Open MPI, Intel MPI (with modulefiles)
- **Intel oneAPI MKL**, **AMD AOCL/AOCC**
- Azure: AZNFS, persistent RDMA naming, udev, network config

**Not installed by default** (no GPU/InfiniBand): NVIDIA driver/CUDA, DOCA/OFED. You can edit `install.sh` to add those if your VM has GPU/IB.

---

## After install

Load the module and run MPI:

```bash
source /usr/share/Modules/init/bash
module avail
module load mpi/openmpi-x.x.x   # or hpcx, mvapich2, impi
mpirun --version
```

---

## One-liner (clone + path only)

If the VM has git and you clone directly on the VM:

```bash
git clone -b rhel9.6-support https://github.com/ariel-adam/azhpc-images.git /tmp/azhpc-images
cd /tmp/azhpc-images/partners/rhel/rhel-9.x/rhel-9.6-hpc
sudo bash install.sh
```

---

## More documentation

- **docs/README.md** – Index of all docs (smoke vs full install, what we added, analysis).
- **RHEL9.6_README.md** – Quick start and pointer to this guide.

---

**Fork:** https://github.com/ariel-adam/azhpc-images  
**Branch:** `rhel9.6-support`  
**Tag:** `rhel9.6-v1`
