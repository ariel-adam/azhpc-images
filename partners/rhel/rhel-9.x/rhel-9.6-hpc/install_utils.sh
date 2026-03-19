#!/bin/bash
set -ex
# RHEL 9.6 install_utils: base packages, repos, kernel-devel, environment-modules
# Uses RHEL repos (no Alma Linux); compatible with azhpc-images component scripts.

source ${UTILS_DIR}/utilities.sh

# Microsoft repo for moby/PMIX etc (RHEL 9)
curl -sSL -o ./microsoft-prod.repo https://packages.microsoft.com/config/rhel/9/prod.repo
cp ./microsoft-prod.repo /etc/yum.repos.d/

dnf repolist
dnf update -y --skip-broken 2>/dev/null || true

# Kernel dev packages (match running kernel) - optional for smoke test
KERNEL=$(uname -r)
dnf install -y kernel-devel kernel-headers kernel-modules-extra 2>/dev/null || true

dnf install -y wget net-tools

# EPEL and CodeReady Builder (CRB) for development packages
dnf install -y epel-release
dnf install -y dnf-plugins-core
dnf config-manager --set-enabled crb 2>/dev/null || dnf config-manager --set-enabled codeready-builder-for-rhel-9-$(arch)-rpms 2>/dev/null || true

# Development Tools and build dependencies
dnf groupinstall -y "Development Tools"
dnf install -y numactl numactl-devel libxml2-devel byacc python3-devel python3-setuptools \
  gtk2 atk cairo tcl tk m4 glibc-devel libudev-devel binutils binutils-devel \
  selinux-policy-devel nfs-utils fuse-libs libpciaccess cmake libnl3-devel \
  libsecret rpm-build make check check-devel lsof kernel-rpm-macros tcsh gcc-gfortran \
  perl azcopy dos2unix

# environment-modules (RHEL 9 AppStream has it)
dnf install -y environment-modules 2>/dev/null || true
if ! command -v module 2>/dev/null; then
  wget -q https://repo.almalinux.org/vault/9.4/BaseOS/x86_64/os/Packages/environment-modules-5.3.0-1.el9.x86_64.rpm -O /tmp/environment-modules.rpm 2>/dev/null && rpm -i /tmp/environment-modules.rpm || true
fi

# kernel-abi-stablelists (for DOCA if used later)
dnf install -y kernel-abi-stablelists 2>/dev/null || true

# Exclude kernel updates (HPC image practice) - only if not already set
grep -q '^exclude=kernel' /etc/dnf/dnf.conf 2>/dev/null || echo "exclude=kernel* kmod*" >> /etc/dnf/dnf.conf
grep -q 'shim\*' /etc/dnf/dnf.conf 2>/dev/null || sed -i '$ s/$/ shim*/' /etc/dnf/dnf.conf
grep -q 'grub2\*' /etc/dnf/dnf.conf 2>/dev/null || sed -i '$ s/$/ grub2*/' /etc/dnf/dnf.conf

# EPEL packages
dnf install -y pssh dkms subunit subunit-devel 2>/dev/null || true

echo ib_ipoib | tee /etc/modules-load.d/ib_ipoib.conf 2>/dev/null || true

# Copy Azure KVP and torset tools (from main components)
$COMMON_DIR/copy_kvp_client.sh || true
$COMMON_DIR/copy_torset_tool.sh || true
