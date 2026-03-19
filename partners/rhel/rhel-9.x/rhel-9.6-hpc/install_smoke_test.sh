#!/bin/bash
# Smoke test: prereqs + set_properties + install_utils + hpc-tuning (no GCC/MPI - proves RHEL 9.6 path works)
set -e
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"

bash install_prerequisites.sh
export GPU=""
export SKU=""
source set_properties.sh
bash install_utils.sh
bash $RHEL_COMMON_DIR/hpc-tuning.sh
echo "=== Smoke test OK ==="
cat /opt/azurehpc/component_versions.txt 2>/dev/null || true
sysctl kernel.pid_max vm.max_map_count 2>/dev/null || true
