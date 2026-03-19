# RHEL 9.6 HPC Support (This Fork)

This fork adds **RHEL 9.6** support to [Azure/azhpc-images](https://github.com/Azure/azhpc-images). Use it to install the same HPC stack (MPI, Lustre, tuning, etc.) on a RHEL 9.6 VM.

---

## Quick start

1. **Clone this branch**
   ```bash
   git clone -b rhel9.6-support https://github.com/ariel-adam/azhpc-images.git
   cd azhpc-images
   ```

2. **Copy to your RHEL 9.6 VM** (e.g. `scp -r azhpc-images user@vm:/tmp/`)

3. **Run the install on the VM**
   ```bash
   cd /tmp/azhpc-images/partners/rhel/rhel-9.x/rhel-9.6-hpc
   sudo bash install.sh
   ```
   Full install takes ~45–90 minutes.

---

## Documentation (everything you can share)

| Document | Purpose |
|----------|---------|
| **[INSTRUCTIONS_FOR_USERS.md](INSTRUCTIONS_FOR_USERS.md)** | **Main user guide** – give this to anyone using the fork. |
| **[docs/README.md](docs/README.md)** | **Index of all docs** – smoke vs full install, what we added, analysis. |
| **[partners/rhel/rhel-9.x/rhel-9.6-hpc/README.md](partners/rhel/rhel-9.x/rhel-9.6-hpc/README.md)** | Quick start and requirements for the install scripts. |

---

**Fork:** https://github.com/ariel-adam/azhpc-images  
**Branch:** `rhel9.6-support`  
**Tag:** `rhel9.6-v1`
