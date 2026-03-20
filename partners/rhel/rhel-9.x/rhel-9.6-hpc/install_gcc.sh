#!/bin/bash
set -ex
source ${UTILS_DIR}/utilities.sh

mkdir -p ${MODULE_FILES_DIRECTORY}

# Build GCC deps into /usr/local so the bootstrap compiler finds MPFR/GMP/MPC (RHEL 9 host libmpfr differs).
DEP_PREFIX=/usr/local
export LD_LIBRARY_PATH=${DEP_PREFIX}/lib64:${DEP_PREFIX}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

# Ensure bootstrap MPFR/GMP are visible to GCC's cc1 when downstream tools (e.g. hpcx_rebuild) invoke gcc without custom LD_LIBRARY_PATH.
printf '%s\n' "${DEP_PREFIX}/lib" "${DEP_PREFIX}/lib64" > /etc/ld.so.conf.d/99-azhpc-gcc-bootstrap.conf
ldconfig

# Install gcc 9.2 prerequisites
GMP_DOWNLOAD_URL=http://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.1.0.tar.bz2
download_and_verify $GMP_DOWNLOAD_URL "498449a994efeba527885c10405993427995d3f86b8768d8cdf8d9dd7c6b73e8"
tar -xvf gmp-6.1.0.tar.bz2
cd ./gmp-6.1.0
./configure --prefix="${DEP_PREFIX}" && make -j"$(nproc)" && make install
cd ..
ldconfig

MPFR_DOWNLOAD_URL=http://gcc.gnu.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2
download_and_verify $MPFR_DOWNLOAD_URL "d3103a80cdad2407ed581f3618c4bed04e0c92d1cf771a65ead662cc397f7775"
tar -xvf mpfr-3.1.4.tar.bz2
cd mpfr-3.1.4
./configure --prefix="${DEP_PREFIX}" --with-gmp="${DEP_PREFIX}" && make -j"$(nproc)" && make install
cd ..
ldconfig

MPC_DOWNLOAD_URL=http://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz
download_and_verify $MPC_DOWNLOAD_URL "617decc6ea09889fb08ede330917a00b16809b8db88c29c31bfbb49cbf88ecc3"
tar -xvf mpc-1.0.3.tar.gz
cd mpc-1.0.3
./configure --prefix="${DEP_PREFIX}" --with-gmp="${DEP_PREFIX}" --with-mpfr="${DEP_PREFIX}" && make -j"$(nproc)" && make install
cd ..
ldconfig

# install gcc 9.2
GCC_VERSION="9.2.0"
GCC_DOWNLOAD_URL=https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
write_component_version "GCC" ${GCC_VERSION}
download_and_verify $GCC_DOWNLOAD_URL "a931a750d6feadacbeecb321d73925cd5ebb6dfa7eff0802984af3aef63759f4"
tar -xvf gcc-${GCC_VERSION}.tar.gz
cd gcc-${GCC_VERSION}
# RHEL 9+ kernels drop linux/cyclades.h; GCC 9.2 libsanitizer still references it.
./configure \
  --disable-multilib \
  --disable-libsanitizer \
  --prefix=/opt/gcc-${GCC_VERSION} \
  --with-gmp="${DEP_PREFIX}" \
  --with-mpfr="${DEP_PREFIX}" \
  --with-mpc="${DEP_PREFIX}"
export LD_LIBRARY_PATH=${DEP_PREFIX}/lib64:${DEP_PREFIX}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
make -j"$(nproc)"
make install
cd ..

# Free disk before MPI/HPC-X stages (~10+ GB of sources/objects)
rm -rf gmp-6.1.0 mpfr-3.1.4 mpc-1.0.3 gcc-${GCC_VERSION}
rm -rf *.tar.gz *.tar.bz2

# create modulefile
cat << EOF >> ${MODULE_FILES_DIRECTORY}/gcc-${GCC_VERSION}
#%Module 1.0
#
#  GCC ${GCC_VERSION}
#
prepend-path    PATH            /opt/gcc-${GCC_VERSION}/bin
prepend-path    LD_LIBRARY_PATH /opt/gcc-${GCC_VERSION}/lib64
setenv          CC              /opt/gcc-${GCC_VERSION}/bin/gcc
setenv          GCC             /opt/gcc-${GCC_VERSION}/bin/gcc
EOF
