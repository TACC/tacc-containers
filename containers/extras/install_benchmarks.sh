#!/bin/bash

set -ex

DIR=osu-micro-benchmarks-5.6.2
curl http://mvapich.cse.ohio-state.edu/download/mvapich/${DIR}.tar.gz | tar -xzf -
cd ${DIR}
./configure --prefix=/opt/ CC=$(which mpicc) CXX=$(which mpicxx)
make -j $(nproc --all 2>/dev/null || echo 2) && make install
mv /opt/libexec/osu-micro-benchmarks/mpi /opt/osu-micro-benchmarks
rm -rf /opt/libexec && find /opt/osu-micro-benchmarks
cd ../ && rm -rf ${DIR} && docker-clean
